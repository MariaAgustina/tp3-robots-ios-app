//
//  HomeViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 12/07/2024.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BagifyTheme.darkBlue

        titleLabel.text = "Bagify"
        titleLabel.font = UIFont(name: "Pacifico-Regular", size: 100)
        titleLabel.textColor = BagifyTheme.lightPink

        takePhotoButton.setTitle("  Sacar Foto", for: .normal)
        submitPhotoButton.setTitle("  Subir Foto", for: .normal)
        setFormatToButton(button:takePhotoButton)
        setFormatToButton(button: submitPhotoButton)
    }

    func setFormatToButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = BagifyTheme.lightPink.cgColor
        button.setTitleColor(BagifyTheme.lightPink, for: .normal)
        button.tintColor = BagifyTheme.lightPink
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        if let customFont = UIFont(name: "Courier-New", size: 50) {
            button.titleLabel?.font = customFont
        }
    }

    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func uploadPhotoFromGalleryButtonPressed(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    

}

extension HomeViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        imagePicker.dismiss(animated: true, completion: nil)

        if var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = image.resized(to: CGSize(width: CGFloat(UIImage.inputWidth), height: CGFloat(UIImage.inputHeight)*image.size.height/image.size.width))
            let searcherViewController = SearcherViewController(nibName: "SearcherViewController", bundle: nil)
            searcherViewController.image = image
            self.navigationController?.pushViewController(searcherViewController, animated: true)
        }
    }
}

