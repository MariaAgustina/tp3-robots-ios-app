//
//  SearchProductsService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import UIKit
import AFNetworking

class SearchProductsService: NSObject {
    
    func searchProduct(product: String, successBlock: @escaping ((ProductsResult)->()), errorBlock: @escaping (()->())){
        
        //TODO: traer 10, y chequear que sean 10 en el enunciado
        let urlString = String(format: "https://api.mercadolibre.com/sites/MLA/search?q=%@", product)
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("Bearer APP_USR-8528745423837358-082423-20756f97fe18ec29afef48c49e766018-185371419", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let productsResult = try? decoder.decode(ProductsResult.self, from: data) {
                        successBlock(productsResult)
                    }
                } else {
                    errorBlock()
                }
            }
        }

        task.resume()

    }
    
}
