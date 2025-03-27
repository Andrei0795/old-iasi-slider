//
//  BeforeAfterSlider.swift
//  Old Iasi Slider
//
//  Created by Andrei Ionescu on 27.03.2025.
//

import SwiftUI

struct BeforeAfterSlider: View {
    let beforeImage: Image
    let afterImage: Image
    @Binding var sliderPosition: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                // BEFORE image (masked from right to left)
                beforeImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    
                
                // AFTER image (full)
                afterImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .mask(
                        HStack {
                            Spacer()
                            Rectangle()
                                .frame(width: (1 - sliderPosition) * width)
                        }
                    )


                // Handle (circle + vertical bar)
                VStack(spacing: 0) {
                    // Circle with arrows
                    Text("<|>")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.black.opacity(0.7)))
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))

                    // Vertical bar
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 2, height: height - 40)
                }
                .position(x: sliderPosition * width, y: height / 2)
                .contentShape(Rectangle()) // Makes entire handle area tappable
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newPosition = min(max(0, value.location.x / width), 1)
                            sliderPosition = newPosition
                        }
                )
                .drawingGroup() // Optimises rendering during drag
            }
        }
        .clipped()
    }
}
