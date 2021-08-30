//
//  DebugOptions.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 29/08/2021.
//

import UIKit

public class DebugOptions {
    static let shared = DebugOptions()
    var shouldDebug : Bool
    
        init(){
            self.shouldDebug = true
        }
        
}
