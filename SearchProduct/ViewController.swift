//
//  ViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Buscador de Productos"
        // Do any additional setup after loading the view.
    }

    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        let takePhotoViewController = TakePhotoViewController(nibName: "TakePhotoViewController", bundle: nil)
        self.navigationController?.pushViewController(takePhotoViewController, animated: true)
    }
    
}

