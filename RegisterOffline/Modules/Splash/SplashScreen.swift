//
//  SplashScreen.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

struct SplashScreen: View {
    var onFinished: () -> Void = {}
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.brandSecondary
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(.imageRegisteroffline)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)

                Text("Register Offline")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(animate ? 1.0 : 0.92)
            .opacity(animate ? 1.0 : 0.4)
            .onAppear {
                withAnimation(.easeOut(duration: 0.50)) {
                    animate = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
