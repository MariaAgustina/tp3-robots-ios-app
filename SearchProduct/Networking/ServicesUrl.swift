//
//  ServicesUrl.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 07/01/2023.
//

import Foundation

struct ServiceURL {

    static let ip = "http://192.168.1.18:8000"
    static let predictImageEndpoint = "/predict-image"

    static func predictImageURL() -> URL {
        URL(string: ServiceURL.ip + ServiceURL.predictImageEndpoint)!
    }
}
