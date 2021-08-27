//
//  SearchProductsService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import UIKit

class SearchProductsService: NSObject {
    
    func searchProduct(product: String, successBlock: @escaping ((ProductsResult)->()), errorBlock: @escaping (()->())){
        
        let urlString = String(format: "https://api.mercadolibre.com/sites/MLA/search?q=%@", product)
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue(Constants.accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let productsResult = try? decoder.decode(ProductsResult.self, from: data) {
                        successBlock(productsResult)
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
