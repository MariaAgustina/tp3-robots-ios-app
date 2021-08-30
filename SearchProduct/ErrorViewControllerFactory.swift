//
//  ErrorViewControllerFactory.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 29/08/2021.
//

import UIKit

class ErrorViewControllerFactory: NSObject {
    static func createErrorViewControllerWithMessage(message: String) -> ErrorViewController{
        let errorViewController = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
        errorViewController.errorDescriptionText = message
        return errorViewController
    }
}
