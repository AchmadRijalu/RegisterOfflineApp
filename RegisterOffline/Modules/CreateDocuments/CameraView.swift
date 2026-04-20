//
//  CameraView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        let frameHorizontalPadding: CGFloat = 26
        let frameHeight: CGFloat = 220
        let captureButtonSize: CGFloat = 72

        ZStack {
            Color.black.ignoresSafeArea()
            switch viewModel.state {
            case .authorized:
                VStack(spacing: 24) {
                    HStack {
                        Button { coordinator.pop() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    CameraPreviewView(session: viewModel.session)
                        .frame(height: frameHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.9), lineWidth: 2)
                        }
                        .padding(.horizontal, frameHorizontalPadding)

                    VStack(spacing: 6) {
                        Text("Letakkan KTP di dalam kotak")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)

                        Text("Agar pencahayaan dan posisi foto pas KTP terbaca dengan jelas")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    Spacer()

                    Button {
                        let frameWidth = UIScreen.main.bounds.width - (frameHorizontalPadding * 2)
                        let ratio = frameWidth / frameHeight
                        viewModel.capturePhoto(targetAspectRatio: ratio) { image in
                            coordinator.capturedKtpImage = image
                            coordinator.push(page: .confirmPhoto)
                        }
                    } label: {
                        Circle()
                            .fill(.white)
                            .frame(width: captureButtonSize, height: captureButtonSize)
                            .overlay {
                                Circle()
                                    .stroke(.black.opacity(0.2), lineWidth: 2)
                                    .padding(4)
                            }
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isCapturing)
                    .padding(.bottom, 30)
                }
            case .denied, .notDetermined:
                VStack(spacing: 16) {
                    HStack {
                        Button { coordinator.pop() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()
                    Image(systemName: "camera.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white.opacity(0.85))

                    Text("Akses kamera dibutuhkan")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Izinkan kamera untuk mengambil foto KTP.")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.75))

                    if viewModel.state == .denied {
                        Button("Buka Pengaturan") {
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(url)
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.brandSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    } else {
                        Button("Izinkan Kamera") {
                            viewModel.prepare()
                        }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.brandSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    Spacer()
                }
            case .failed(let reason):
                VStack(spacing: 12) {
                    HStack {
                        Button { coordinator.pop() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.yellow)
                    Text(reason)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { viewModel.prepare() }
        .onDisappear { viewModel.stop() }
    }
}

private struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        uiView.previewLayer.session = session
    }

    final class PreviewUIView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}

#Preview {
    NavigationStack {
        CameraView()
            .environmentObject(Coordinator(injection: Injection()))
    }
}
