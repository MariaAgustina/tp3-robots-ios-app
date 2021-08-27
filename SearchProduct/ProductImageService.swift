//
//  ProductImageService.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 27/08/2021.
//

import UIKit

class ProductImageService: NSObject {
    func getImage(url: String, successBlock: @escaping ((UIImage)->()), errorBlock: @escaping (()->())){
        
        let urlString = String(format: url)
        let request = URLRequest(url: URL(string: urlString)!)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    if let image : UIImage = UIImage(data: data) {
                        successBlock(image)
                    }else{
                        print("Error in creating product image")
                        errorBlock()
                    }
                } else {
                    print(error ?? "Error in requesting product image")
                }
            }
        }

        task.resume()

    }
}
