//
//  BeforeAfterDetailView.swift
//  Old Iasi Slider
//
//  Created by Andrei Ionescu on 27.03.2025.
//

import SwiftUI

struct BeforeAfterDetailView: View {
    let pair: BeforeAfterImage
    let namespace: Namespace.ID
    let onClose: () -> Void

    @State private var sliderPosition: CGFloat = 1.0
    var body: some View {
        let horizontalPadding: CGFloat = 16

        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            GeometryReader { geometry in
                VStack(spacing: 16) {
                    
                    Spacer()

                    if let uiImage = UIImage(named: pair.beforeName) {
                        let imageAspectRatio = uiImage.size.width / uiImage.size.height
                        let width = UIScreen.main.bounds.width * 0.9
                        let height = width / imageAspectRatio

                        BeforeAfterSlider(
                            beforeImage: Image(uiImage: uiImage),
                            afterImage: Image(pair.afterName),
                            sliderPosition: $sliderPosition
                        )
                        .resizableMatchWrapper()
                        .matchedGeometryEffect(id: pair.id, in: namespace)
                        .clipped() 
                        .frame(width: width, height: height)
                        .onTapGesture {}
                    }

                    Spacer()
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    sliderPosition = 0.5
                }
            }
        }
    }
}
