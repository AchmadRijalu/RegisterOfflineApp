//
//  CameraViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import AVFoundation
import Combine
import UIKit

@MainActor
final class CameraViewModel: NSObject, ObservableObject {

    enum CameraState: Equatable {
        case notDetermined
        case authorized
        case denied
        case failed(String)
    }

    @Published private(set) var state: CameraState = .notDetermined
    @Published private(set) var isCapturing = false

    let session = AVCaptureSession()

    private let output = AVCapturePhotoOutput()
    private var isSessionConfigured = false
    private var pendingCapture: PendingCapture?

    private struct PendingCapture {
        let targetAspectRatio: CGFloat
        let completion: (UIImage) -> Void
    }
}

extension CameraViewModel {
    func prepare() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            state = .authorized
            startSession()
        case .notDetermined:
            requestAccess()
        default:
            state = .denied
        }
    }

    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
}

extension CameraViewModel {
    func capturePhoto(targetAspectRatio: CGFloat, completion: @escaping (UIImage) -> Void) {
        guard state == .authorized, !isCapturing else { return }
        isCapturing = true
        pendingCapture = PendingCapture(targetAspectRatio: targetAspectRatio, completion: completion)
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        output.capturePhoto(with: settings, delegate: self)
    }
}

private extension CameraViewModel {
    func requestAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.state = granted ? .authorized : .denied
                if granted { self.startSession() }
            }
        }
    }

    func startSession() {
        if !isSessionConfigured {
            configureSession()
            isSessionConfigured = true
        }
        guard !session.isRunning else { return }
        session.startRunning()
    }

    func configureSession() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.sessionPreset = .photo

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            state = .failed("Camera device unavailable.")
            return
        }

        if session.inputs.isEmpty { session.addInput(input) }
        if session.canAddOutput(output), session.outputs.isEmpty { session.addOutput(output) }
    }

    func cropToAspectRatio(_ image: UIImage, ratio: CGFloat) -> UIImage {
        guard ratio > 0, let cgImage = image.cgImage else { return image }

        let w = CGFloat(cgImage.width)
        let h = CGFloat(cgImage.height)
        let sourceRatio = w / h

        var cropRect = CGRect(x: 0, y: 0, width: w, height: h)

        if sourceRatio > ratio {
            let cropW = h * ratio
            cropRect = CGRect(x: (w - cropW) / 2, y: 0, width: cropW, height: h)
        } else {
            let cropH = w / ratio
            cropRect = CGRect(x: 0, y: (h - cropH) / 2, width: w, height: cropH)
        }

        guard let cropped = cgImage.cropping(to: cropRect.integral) else { return image }
        return UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        Task { @MainActor in
            defer {
                isCapturing = false
                pendingCapture = nil
            }

            guard
                error == nil,
                let data = photo.fileDataRepresentation(),
                let image = UIImage(data: data),
                let capture = pendingCapture
            else { return }

            let result = cropToAspectRatio(image, ratio: capture.targetAspectRatio)
            capture.completion(result)
        }
    }
}
