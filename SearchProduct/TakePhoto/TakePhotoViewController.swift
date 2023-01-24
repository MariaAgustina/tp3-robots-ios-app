//
//  TakePhotoViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 25/08/2021.
//

import UIKit
import PhotosUI

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var searchProductsButton: UIButton!
    @IBOutlet weak var takePhotoImageView: UIImageView!
    var image: UIImage?
    var imagePicker: UIImagePickerController!
    private let predictImageService = PredictImageService()

    var activityIndicatorView : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchProductsButton.isEnabled = false

        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100 ,y: 200, width: 50, height: 50)) as UIActivityIndicatorView
        activityIndicatorView?.center = self.view.center
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView?.style = .large
        activityIndicatorView?.color = .white

    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoButtonPressed(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func searchProductsButtonPressed(_ sender: UIButton) {
        
        guard let image = takePhotoImageView.image else{
            print("No product to search found")
            return
        }

        predictImage(image: image)

    }

    func predictImage(image: UIImage){
        guard let pngData = image.pngData() else {
            return
        }
        let imageData = ProductWithImage(withImage: pngData, andId: "prediction_image")
        activityIndicatorView?.startAnimating()
        predictImageService.predictImage(image: imageData) { [weak self] result in
            switch result {
            case .success(let product):
                print("Service success")
                if let url = URL(string: product.permalink ?? ""){
                    print("url:" + url.absoluteString )
                    UIApplication.shared.open(url)
                    self?.activityIndicatorView?.stopAnimating()
                }
            case .failure(let error):
                print("Service error" + error.localizedDescription)
            }
        }

    }
    
}

extension TakePhotoViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        for subview in self.takePhotoImageView.subviews{
            subview.removeFromSuperview()
        }
        
        takePhotoImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = image.resized(to: CGSize(width: CGFloat(UIImage.inputWidth), height: CGFloat(UIImage.inputHeight)*image.size.height/image.size.width))
            takePhotoImageView.image = image
            searchProductsButton.isEnabled = true
        }
    }
}
