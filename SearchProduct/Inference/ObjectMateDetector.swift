//
//  ObjectMateDetector.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 28/08/2021.
//

import UIKit

class ObjectMateDetector {
    lazy var module: InferenceModule = {
        if let filePath = Bundle.main.path(forResource: "weights.torchscript", ofType: "pt"),
            let module = InferenceModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Failed to load mate model!")
        }
    }()
    
    lazy var classes: [String] = {
        if let filePath = Bundle.main.path(forResource: "words-mate", ofType: "txt"),
            let classes = try? String(contentsOfFile: filePath) {
            return classes.components(separatedBy: .newlines)
        } else {
            fatalError("classes file words-mate was not found.")
        }
    }()
    
    static let output_size = 25200*10
    static let columns = 10 // left, top, right, bottom, score and 5 class probability

}
