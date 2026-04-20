//
//  BottomSheet.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: () -> SheetContent

    private let insertAnimation = Animation.spring(response: 0.35, dampingFraction: 0.75)
    private let dismissAnimation = Animation.easeInOut(duration: 0.25)

    @State private var isSheetVisible = false
    @State private var sheetOffset: CGFloat = 0
    @State private var backgroundOpacity: CGFloat = 0
    @State private var screenHeight: CGFloat = 0

    func body(content: Content) -> some View {
        ZStack {
            content
                .background(GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            let newHeight = proxy.size.height
                            if screenHeight != newHeight {
                                screenHeight = newHeight
                            }
                        }
                        .onChange(of: proxy.size.height) { newHeight in
                            if screenHeight != newHeight {
                                screenHeight = newHeight
                            }
                        }
                })

            if isSheetVisible {
                Color.black.opacity(0.3 * backgroundOpacity)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                    .zIndex(1)

                VStack {
                    Spacer()
                    sheetContent()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .offset(y: sheetOffset)
                }
                .ignoresSafeArea(edges: .bottom)
                .zIndex(2)
            }
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                dismissKeyboard()
                sheetOffset = screenHeight
                backgroundOpacity = 0
                isSheetVisible = true
                withAnimation(insertAnimation) {
                    sheetOffset = 0
                    backgroundOpacity = 1
                }
            } else {
                dismissSheet()
            }
        }
    }

    private func dismissSheet() {
        withAnimation(dismissAnimation) {
            sheetOffset = screenHeight
            backgroundOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            isSheetVisible = false
            sheetOffset = 0
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(isPresented: isPresented, sheetContent: content))
    }
}
