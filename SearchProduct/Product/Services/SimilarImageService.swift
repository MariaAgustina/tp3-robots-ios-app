//
//  SimilarImageService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 29/08/2021.
//

import UIKit

class SimilarImageService: NSObject {
    
    func getMostSimilarImage(productsWithImage:[ProductWithImage],successBlock: @escaping (([ProductSimilarity])->()), errorBlock: @escaping (()->())){
        var request = URLRequest(url: ServiceURL.similarImageURL())

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let encoder = JSONEncoder()
        try? request.httpBody = encoder.encode(productsWithImage)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

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
