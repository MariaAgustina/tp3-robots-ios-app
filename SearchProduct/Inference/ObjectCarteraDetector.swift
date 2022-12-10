//
//  ObjectCarteraDetector.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 06/12/2022.
//

import UIKit

class ObjectCarteraDetector {
    lazy var module: InferenceModule = {
        if let filePath = Bundle.main.path(forResource: "best-640.torchscript", ofType: "ptl"),
            let module = InferenceModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Failed to load cartera model!")
        }
    }()

    lazy var classes: [String] = {
        if let filePath = Bundle.main.path(forResource: "words-cartera", ofType: "txt"),
            let classes = try? String(contentsOfFile: filePath) {
            return classes.components(separatedBy: .newlines)
        } else {
            fatalError("classes file words-mate was not found.")
        }
    }()

    static let output_size = 25200*6
    static let columns = 6 // left, top, right, bottom, score and 1 class probability

}
