//
//  ClassTranslator.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 27/08/2021.
//

import UIKit

class ClassTranslator: NSObject {
    static let translations =   ["backpack":"mochila",
                                "umbrella":"paraguas",
                                "handbag":"cartera",
                                "tie":"corbata",
                                "suitcase":"valija",
                                "sports ball":"pelota",
                                "racket":"tennis",
                                "bottle":"botella de agua",
                                "cup":"taza",
                                "chair":"silla",
                                "couch":"sofa",
                                "refrigerator":"heladera",
                                "clock":"reloj",
                                "vase":"jarron",
                                "teddy bear":"oso de peluche",
                                "hair drier":"secador de pelo",
                                "skateboard":"skateboard",
                                "snowboard":"snowboard",
                                "surfboard":"surfboard",
                                "bowl":"bowl",
                                "mate":"mate",
                                "calabaza":"calabaza",
                                "plastico":"plastico",
                                "madera":"madera",
                                "metal":"metal",
                                "cartera":"cartera"
                                ]
    
    static func translate(word: String) -> String? {
        return self.translations[word] ?? nil
    }
}
