//
//  ErrorViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 29/08/2021.
//

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet public weak var errorTitle: UILabel!
    @IBOutlet public weak var errorDescription: UILabel!
    
    public var errorDescriptionText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorDescription.text = self.errorDescriptionText
    }

    @IBAction func tryAgainButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
