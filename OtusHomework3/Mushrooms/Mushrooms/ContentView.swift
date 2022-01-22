//
//  ContentView.swift
//  Mushrooms
//
//  Created by Дарья Сербер on 21.01.2022.
//

import SwiftUI

final class ImageData: ObservableObject {
    @Published var image = UIImage()
}

struct ContentView: View {
    
    @StateObject var predictMushroomViewModel: PredictMushroomViewModel = .init()
    @StateObject var imageData: ImageData = .init()
    
    @State private var isShowPhotoLibrary = false
    
    var body: some View {
        VStack {
            Image(uiImage: self.imageData.image)
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 350)
                .border(Color.blue)
                .clipped()
                .background(Color.blue.opacity(0.1))
            Text(predictMushroomViewModel.label)
                .font(.headline)
                .padding()
            Spacer()
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    
                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$imageData.image)
        }
        .onReceive(imageData.$image) { predictMushroomViewModel.runDetector(for: $0) }
    }
}
