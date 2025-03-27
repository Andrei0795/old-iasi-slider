
//
//  ContentView.swift
//  Old Iasi Slider
//
//  Created by Andrei Ionescu on 27.03.2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Namespace private var namespace
    @State private var selectedImage: BeforeAfterImage? = nil
    @State private var showDetail = false
    @State private var animatingImage: BeforeAfterImage? = nil
    @State private var tempImageDissapear: Bool = false
    @State private var showCredits = false
    
    private let imagePairs = [
        BeforeAfterImage(beforeName: "before1", afterName: "after1"),
        BeforeAfterImage(beforeName: "before2", afterName: "after2"),
        BeforeAfterImage(beforeName: "before3", afterName: "after3"),
        BeforeAfterImage(beforeName: "before4", afterName: "after4"),
        BeforeAfterImage(beforeName: "before5", afterName: "after5")
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let spacing: CGFloat = 16
                let horizontalPadding: CGFloat = 16
                let totalSpacing = spacing + horizontalPadding * 2
                let columnWidth = (geometry.size.width - totalSpacing) / 2
                
                let columns = [
                    GridItem(.fixed(columnWidth), spacing: spacing),
                    GridItem(.fixed(columnWidth), spacing: spacing)
                ]
                
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(imagePairs) { pair in
                                Image(pair.beforeName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: columnWidth, height: 150)
                                    .clipped()
                                    .cornerRadius(12)
                                    .matchedGeometryEffect(id: pair.id, in: namespace, isSource: selectedImage?.id == pair.id)
                                    .zIndex(selectedImage?.id == pair.id && !showDetail ? 2 : 0) // Higher zIndex when selected and not in detail
                                    .opacity(animatingImage?.id == pair.id && showDetail ? 0 : 1) // Fade out grid image when animating
                                    .onTapGesture {
                                        if !showDetail {
                                            selectedImage = pair
                                            animatingImage = pair
                                            // Capture the frame of the tapped item (optional, but might be useful for more complex animations)
                                            
                                            withAnimation(.easeInOut(duration: 0.4)) {
                                                showDetail = true
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, spacing)
                    }
                    
                    // Conditionally show the animating image at the top level
                    if let animating = animatingImage, showDetail, !tempImageDissapear {
                        if let uiImage = UIImage(named: animating.beforeName) {
                            let aspectRatio = uiImage.size.width / uiImage.size.height
                            let width = UIScreen.main.bounds.width * 0.9
                            let height = width / aspectRatio
                            
                            Spacer()
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: width, height: height)
                                .matchedGeometryEffect(id: animating.id, in: namespace, isSource: selectedImage?.id == animating.id)
                                .zIndex(3)
                                .transition(.identity)
                                .onAppear() {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        tempImageDissapear = true
                                    }
                                }
                            Spacer()
                        }
                    }
                    
                    if let selected = selectedImage, showDetail {
                        ZStack {
                            Color.black.opacity(0.6)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    close(selected)
                                }
                            
                            BeforeAfterDetailView(
                                pair: selected,
                                namespace: namespace,
                                onClose: {
                                    close(selected)
                                }
                            )
                            .transition(.identity) // Ensure detail view appears without its own animation conflicting
                            .onAppear()
                        }
                    }
                }
            }
            .navigationTitle("Old Iași Slider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Credits") {
                        showCredits = true
                    }
                    .opacity(showDetail == true ? 0 : 1)
                }
            }
            .alert("Credits", isPresented: $showCredits) {
                Button("OK", role: .cancel) { }
                Button("Open Facebook") {
                    if let url = URL(string: "https://www.facebook.com/iasifotografiivechi") {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("Credits for the images belong to Iasi Fotografii Vechi")
            }
        }
    }

    private func close(_ pair: BeforeAfterImage) {
        tempImageDissapear = false

        withAnimation(.easeInOut(duration: 0.4)) {
            showDetail = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            selectedImage = nil
            animatingImage = nil
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
