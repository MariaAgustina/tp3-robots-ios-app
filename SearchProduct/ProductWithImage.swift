//
//  ProductWithImage.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 27/08/2021.
//

import UIKit

class ProductWithImage: NSObject {
    var image : UIImage
    var id : String
    
    init(withImage image: UIImage, andId id: String) {
        self.image = image
        self.id = id
        super.init()
    }
}
