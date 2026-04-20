//
//  ConfirmationCardView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftUI

struct ConfirmationCardView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Tinjau Gambar")
                    .font(.system(size: 30, weight: .bold))
                   

                Text("Pastikan foto KTP jelas dan mudah dibaca")
                    .font(.system(size: 14))
                    

                Group {
                    if let capturedImage = coordinator.capturedKtpImage {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 190)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    } else {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(hex: "#BEE3F8"))
                            .frame(height: 190)
                            .overlay {
                                Image(systemName: "person.text.rectangle")
                                    .font(.system(size: 58))
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                    }
                }
                .padding(.horizontal, 16)

                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Kualitas foto ini sudah baik")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "#065F46"))
                    Spacer()
                }
                .padding(.horizontal, 12)
                .frame(height: 42)
                .background(Color(hex: "#D1FAE5"))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 16)

                Spacer()
            }

            VStack(spacing: 10) {
                GeneralButton(
                    title: "Gunakan foto ini",
                    type: .filled,
                    tint: .primary,
                    height: 50,
                    cornerRadius: 10,
                    titleFont: .system(size: 16, weight: .semibold),
                    action: {
                        switch coordinator.currentCaptureSlot {
                        case .primary:
                            coordinator.primaryKtpImage = coordinator.capturedKtpImage
                            coordinator.hasPrimaryKtpPhoto = true
                        case .secondary:
                            coordinator.secondaryKtpImage = coordinator.capturedKtpImage
                            coordinator.hasSecondaryKtpPhoto = true
                        }
                        coordinator.capturedKtpImage = nil
                        coordinator.pop(count: 2)
                    }
                )

                GeneralButton(
                    title: "Ambil foto ulang",
                    type: .outlined,
                    tint: .primary,
                    height: 50,
                    cornerRadius: 10,
                    titleFont: .system(size: 16, weight: .semibold),
                    stroke: Color(hex: "#D1D5DB"),
                    fill: .white,
                    action: {
                        coordinator.pop()
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(.white)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.black.opacity(0.05))
                    .frame(height: 1)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ConfirmationCardView()
        .environmentObject(Coordinator(injection: Injection()))
}
