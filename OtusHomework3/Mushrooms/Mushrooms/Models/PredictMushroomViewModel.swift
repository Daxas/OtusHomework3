//
//  PredictMushroomViewModel.swift
//  Mushrooms
//
//  Created by Дарья Сербер on 21.01.2022.
//

import Vision
import SwiftUI

final class PredictMushroomViewModel: ObservableObject {
    
    @Published var label = "Unknown mushroom"
    
    func runDetector(for image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MushroomsClassifier().model) else {
            label = "MODEL ERROR"
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.handleResult(request: request, error: error)
        }
        request.imageCropAndScaleOption = .centerCrop
        
        guard let cgImage = image.cgImage else {
            label = "Please load image"
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }
    
    private func handleResult(request: VNRequest, error: Error?) {
        if let mushrooms = request.results as? [VNClassificationObservation] {
            guard let result = mushrooms.first?.identifier else {
                return
            }
            let text = "Вероятно, это - " + result
            self.label = text.uppercased()
        } else if let error = error {
            self.label = error.localizedDescription
        }
    }
}
