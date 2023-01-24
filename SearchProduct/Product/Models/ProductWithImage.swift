//
//  ProductWithImage.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 27/08/2021.
//

import UIKit

struct ProductWithImage: Codable {
    var image : Data
    var id : String
    
    init(withImage image: Data, andId id: String) {
        self.image = image
        self.id = id
    }
}
