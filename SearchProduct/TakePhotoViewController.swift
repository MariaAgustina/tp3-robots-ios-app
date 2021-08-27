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
    private var inferencer = ObjectDetector()
    
    var productsWithImage : [ProductWithImage]?
    var productsResult : ProductsResult?
    var productToSearch : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productsWithImage = []
        self.searchProductsButton.isEnabled = false

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
    
    func searchProduct(product: String){
        let searchProductService = SearchProductsService()
        //TODO: show loading
        searchProductService.searchProduct(product: product) { productsResult in
            self.productsResult = productsResult
            let dispatchGroup = DispatchGroup()
            let productImageService = ProductImageService()
            if let results = productsResult.results {
                for product in results{
                    dispatchGroup.enter()
                    productImageService.getImage(url: product.thumbnail ?? "") { [weak self] image in
                        guard let strongSelf = self else { return }
                        let productWithImage = ProductWithImage(withImage: image, andId: product.id)
                        strongSelf.productsWithImage?.append(productWithImage)
                        dispatchGroup.leave()
                    } errorBlock: {
                        //TODO
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                //TODO: buscar la imagen mas parecida dentro de productsWithImage, luego deberiamos obtener el string de la url del array de resultados, por ahora agarramos solo el primero
                let productFoundId = self.productsWithImage?.first?.id
                let productResult = self.productsResult?.results?.filter{ $0.id == productFoundId }.first
                if let url = URL(string: productResult?.permalink ?? ""){
                    UIApplication.shared.open(url)
                }else{
                    //TODO: ERROR NO ENCONTRO EL LINK
                }
            })
            
        } errorBlock: {
            //TODO
        }



    }
    
    
    @IBAction func searchProductsButtonPressed(_ sender: UIButton) {
        
        guard let productToSearch = self.productToSearch else{
            print("No product to search found")
            return
        }
        
        searchProduct(product: productToSearch)
        
    }
    
}

extension TakePhotoViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = image!.resized(to: CGSize(width: CGFloat(PrePostProcessor.inputWidth), height: CGFloat(PrePostProcessor.inputHeight)*image!.size.height/image!.size.width))
        takePhotoImageView.image = image
        
        let resizedImage = image!.resized(to: CGSize(width: CGFloat(PrePostProcessor.inputWidth), height: CGFloat(PrePostProcessor.inputHeight)))
        
        let imgScaleX = Double(image!.size.width / CGFloat(PrePostProcessor.inputWidth));
        let imgScaleY = Double(image!.size.height / CGFloat(PrePostProcessor.inputHeight));
        
        let ivScaleX : Double = (image!.size.width > image!.size.height ? Double(takePhotoImageView.frame.size.width / takePhotoImageView.image!.size.width) : Double(takePhotoImageView.image!.size.width / takePhotoImageView.image!.size.height))
        let ivScaleY : Double = (image!.size.height > image!.size.width ? Double(takePhotoImageView.frame.size.height / takePhotoImageView.image!.size.height) : Double(takePhotoImageView.image!.size.height / takePhotoImageView.image!.size.width))

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
            for prediction in nmsPredictions {
                print("Prediccion = Clase: " +  self.inferencer.classes[prediction.classIndex] + " Confianza: " + String(prediction.score))
            }

            DispatchQueue.main.async {
                PrePostProcessor.showDetection(imageView: self.takePhotoImageView, nmsPredictions: nmsPredictions, classes: self.inferencer.classes)
                if let classIndex = nmsPredictions.first?.classIndex{
                    let word = self.inferencer.classes[classIndex]
                    self.productToSearch = ClassTranslator.translate(word: word)
                    self.searchProductsButton.isEnabled = true
                    self.searchProductsButton.setTitle("Buscar " + (self.productToSearch ?? ""), for: .normal)
                }
                
            }
        }
    }
}

