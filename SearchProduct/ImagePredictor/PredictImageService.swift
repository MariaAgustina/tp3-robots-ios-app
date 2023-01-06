//
//  PredictImageService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 06/01/2023.
//

import Foundation


class PredictImageService: NSObject {

    func predictImage(
        image: UIImage,
        //TODO: completion block etc
        successBlock: @escaping (([ProductSimilarity])->()),
        errorBlock: @escaping (()->())
    ){
        var request = URLRequest(url: URL(string: "http://192.168.1.54:8000/predict-image")!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let encoder = JSONEncoder()
        try? request.httpBody = encoder.encode(image.pngData())

        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let productsSimilarity = try? decoder.decode([ProductSimilarity].self, from: data) {
                        successBlock(productsSimilarity)
                    }
                } else {
                    print(error ?? "Error in requesting products")
                    errorBlock()
                }
            }
        }

        task.resume()
    }
}
