//
//  TakePhotoViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 25/08/2021.
//

import UIKit

class TakePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    private var inferencer = ObjectDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func searchProductsButtonPressed(_ sender: UIButton) {
        
//        btnRun.isEnabled = false
//        btnRun.setTitle("Running the model...", for: .normal)

        let resizedImage = takePhotoImageView.image!.resized(to: CGSize(width: CGFloat(PrePostProcessor.inputWidth), height: CGFloat(PrePostProcessor.inputHeight)))
        
        let imgScaleX = Double(takePhotoImageView.image!.size.width / CGFloat(PrePostProcessor.inputWidth));
        let imgScaleY = Double(takePhotoImageView.image!.size.height / CGFloat(PrePostProcessor.inputHeight));
        
        let ivScaleX : Double = (takePhotoImageView.image!.size.width > takePhotoImageView.image!.size.height ? Double(takePhotoImageView.frame.size.width / takePhotoImageView.image!.size.width) : Double(takePhotoImageView.image!.size.width / takePhotoImageView.image!.size.height))
        let ivScaleY : Double = (takePhotoImageView.image!.size.height > takePhotoImageView.image!.size.width ? Double(takePhotoImageView.frame.size.height / takePhotoImageView.image!.size.height) : Double(takePhotoImageView.image!.size.height / takePhotoImageView.image!.size.width))

        let startX = Double((takePhotoImageView.frame.size.width - CGFloat(ivScaleX) * takePhotoImageView.image!.size.width)/2)
        let startY = Double((takePhotoImageView.frame.size.height -  CGFloat(ivScaleY) * takePhotoImageView.image!.size.height)/2)

        guard var pixelBuffer = resizedImage.normalized() else {
            return
        }
        
        DispatchQueue.global().async {
            guard let outputs = self.inferencer.module.detect(image: &pixelBuffer) else {
                return
            }
            
            let nmsPredictions = PrePostProcessor.outputsToNMSPredictions(outputs: outputs, imgScaleX: imgScaleX, imgScaleY: imgScaleY, ivScaleX: ivScaleX, ivScaleY: ivScaleY, startX: startX, startY: startY)
            
            DispatchQueue.main.async {
                PrePostProcessor.showDetection(imageView: self.takePhotoImageView, nmsPredictions: nmsPredictions, classes: self.inferencer.classes)
//                self.btnRun.isEnabled = true
//                self.btnRun.setTitle("Detect", for: .normal)
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        takePhotoImageView.image = info[.originalImage] as? UIImage
    }
}
