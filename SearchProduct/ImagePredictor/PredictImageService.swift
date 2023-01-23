//
//  PredictImageService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 06/01/2023.
//

import Foundation

enum NetworkError: Error{
    case networkError
}

class PredictImageService: NSObject {

    func predictImage(
        image: ProductWithImage,
        completionHandler: @escaping (Result<Product, Error>) -> Void
    ){

        var request = URLRequest(url: ServiceURL.predictImageURL())
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let encoder = JSONEncoder()
        try? request.httpBody = encoder.encode(image)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let prediction = try? decoder.decode(Product.self, from: data) {
                        completionHandler(.success(prediction))
                    }
                } else {
                    print(error ?? "Error in requesting image prediction")
                    completionHandler(.failure(NetworkError.networkError))

                }
            }
        }

        task.resume()
    }
}
