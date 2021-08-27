//
//  Product.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import Foundation

struct Product : Codable {
    var thumbnail: String?
    var permalink : String?
    var title: String?
    var price: Double?
    var id: String
}
