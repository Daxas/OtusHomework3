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
    
    func runDetector(image: UIImage) {
        
        guard let model = try? VNCoreMLModel(for: MushroomsClassifier().model) else {
            label = "MODEL ERROR"
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.handleResult(request: request, error: error)
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
    }
    
    private func handleResult(request: VNRequest, error: Error?) {
        if let mushrooms = request.results as? [VNClassificationObservation] {
            var result = "Вероятно это - "
            let top3 = mushrooms.prefix(through: 2)
            top3.forEach { result.append(contentsOf: $0.identifier + " или ") }
            result.removeLast(5)
            self.label = result.uppercased()
        }
    }
}
