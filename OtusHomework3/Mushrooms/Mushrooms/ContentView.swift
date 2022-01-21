//
//  ContentView.swift
//  Mushrooms
//
//  Created by Дарья Сербер on 21.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var predictMushroomViewModel: PredictMushroomViewModel = .init()
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage() {
        didSet {
            predictMushroomViewModel.runDetector(image: self.image)
        }
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
            Text(predictMushroomViewModel.label)
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
            ImagePicker(selectedImage: self.$image)
        }
        .onAppear {
            
        }
    }
}
