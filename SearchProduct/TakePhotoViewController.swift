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
    private var mateInferencer = ObjectCarteraDetector()

    var productsWithImage : [ProductWithImage]?
    var productsResult : ProductsResult?
    var productToSearch : String?
    var activityIndicatorView : UIActivityIndicatorView?
    var materialToSearch : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productsWithImage = []
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
    
    func searchProduct(product: String){
        self.productsWithImage = []
        let searchProductService = SearchProductsService()
        self.activityIndicatorView?.startAnimating()
        searchProductService.searchProduct(product: product) { [weak self] productsResult in
            guard let strongSelf = self else { return }
            strongSelf.productsResult = productsResult
            let dispatchGroup = DispatchGroup()
            let productImageService = ProductImageService()
            if let results = productsResult.results {
                for product in results{
                    dispatchGroup.enter()
                    productImageService.getImage(url: product.thumbnail ?? "") { [weak self] image in
                        guard let strongSelf = self else { return }
                        let productWithImage = ProductWithImage(withImage: image.pngData()!, andId: product.id)
                        strongSelf.productsWithImage?.append(productWithImage)
                        dispatchGroup.leave()
                    } errorBlock: {
                        let errorViewController = ErrorViewControllerFactory.createErrorViewControllerWithMessage(message: "No se encontraron productos en la busqueda, revise la autenticacion")
                        strongSelf.navigationController?.pushViewController(errorViewController, animated: true)
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                if strongSelf.productsResult?.results == nil {
                    let errorViewController = ErrorViewControllerFactory.createErrorViewControllerWithMessage(message: "No se encontraron productos en la busqueda, revise la autenticacion")
                    strongSelf.navigationController?.pushViewController(errorViewController, animated: true)

                }
                strongSelf.getSimilarImage()
            })
            
        } errorBlock: {
            self.activityIndicatorView?.stopAnimating()
            let errorViewController = ErrorViewControllerFactory.createErrorViewControllerWithMessage(message: "Parece que hubo un error de conexion")
            self.navigationController?.pushViewController(errorViewController, animated: true)
        }

    }
    
    func getSimilarImage(){
        let similarImageService = SimilarImageService()
        let productToCompare = ProductWithImage(withImage: self.takePhotoImageView.image!.pngData()!, andId: "input_product")
        self.productsWithImage?.append(productToCompare)
        similarImageService.getMostSimilarImage(productsWithImage:self.productsWithImage ?? [], successBlock:{ productsSimilarities in
            self.activityIndicatorView?.stopAnimating()
            self.saveImagesSimilaritiesIfNeeded(productSimilarities: productsSimilarities)
            let productFoundId = productsSimilarities.first?.similar_pi //similarities of products are in order
            print("Product found id:")
            print(productFoundId ?? "")
            print("Products results:")
            print(self.productsResult?.results!)
            let productResult = self.productsResult?.results?.filter{ $0.id == productFoundId }.first
            if let url = URL(string: productResult?.permalink ?? ""){
                print("url:" + url.absoluteString )
                UIApplication.shared.open(url)
            }
        },errorBlock:{
        })
    }
    
    
    @IBAction func searchProductsButtonPressed(_ sender: UIButton) {
        
        guard let productToSearch = self.productToSearch else{
            print("No product to search found")
            return
        }
        
        searchProduct(product: productToSearch)
        
    }
    
    func saveImagesSimilaritiesIfNeeded(productSimilarities:[ProductSimilarity]){
        guard DebugOptions.shared.shouldDebug else { return }
        guard let productsWithImage = self.productsWithImage else { return }
        for product in productsWithImage {
            let pngData: NSData = product.image as NSData
            
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsPath = paths.firstObject
            
            let productId : String = product.id
            let similarity : String = String(productSimilarities.filter{ $0.similar_pi == productId }.first?.similarity ?? 0)
            let suffix_file  : String = similarity + "_" + productId + ".png"
            let filePath : String = documentsPath as! String + "/" + suffix_file
            do {
                try pngData.write(toFile: filePath, options: .withoutOverwriting)
            }catch{
                print("Unexpected error saving image: \(error).")
            }
        }
    }
    
    func saveImageResultIfNeeded(){
        guard DebugOptions.shared.shouldDebug else { return }
        let renderer = UIGraphicsImageRenderer(size: takePhotoImageView.bounds.size)
        let imageWithLayers : UIImage = renderer.image { ctx in
            takePhotoImageView.drawHierarchy(in: takePhotoImageView.bounds, afterScreenUpdates: true)
        }
        let pngData: NSData = imageWithLayers.pngData()! as NSData
        
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsPath = paths.firstObject
        let filePath : String = documentsPath as! String + "/result.png"
        do {
            try pngData.write(toFile: filePath, options: .withoutOverwriting)
        }catch{
            print("Unexpected error saving image: \(error).")
        }
    }
    
}

extension TakePhotoViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.materialToSearch = ""
        self.productToSearch = ""
        
        for subview in self.takePhotoImageView.subviews{
            subview.removeFromSuperview()
        }
        
        self.takePhotoImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
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
        
        //predict mate
        DispatchQueue.global().async {
            guard let outputsMate = self.mateInferencer.module.detect(image: &pixelBuffer,outputSize: ObjectCarteraDetector.output_size) else {
                return
            }

            let nmsPredictions = PrePostProcessor.outputsToNMSPredictions(outputs: outputsMate,outputColumn: ObjectCarteraDetector.columns, imgScaleX: imgScaleX, imgScaleY: imgScaleY, ivScaleX: ivScaleX, ivScaleY: ivScaleY, startX: startX, startY: startY)
            for prediction in nmsPredictions {
                print("Prediccion = Clase: " +  self.mateInferencer.classes[prediction.classIndex] + " Confianza: " + String(prediction.score))
                let posibleMaterial = self.mateInferencer.classes[prediction.classIndex]
                if(posibleMaterial == "calabaza" || posibleMaterial == "metal" || posibleMaterial == "plastico" || posibleMaterial == "madera"){
                    self.materialToSearch = posibleMaterial
                }
            }

            if nmsPredictions.count > 0 {
                DispatchQueue.main.async {
                    PrePostProcessor.showDetection(imageView: self.takePhotoImageView, nmsPredictions: nmsPredictions, classes: self.mateInferencer.classes)
                    if let classIndex = nmsPredictions.first?.classIndex{
                        let word = self.mateInferencer.classes[classIndex]
                        self.productToSearch = ClassTranslator.translate(word: word)
                        self.searchProductsButton.isEnabled = true
                        if(self.materialToSearch != ""){
                            self.productToSearch = "cartera " + (self.materialToSearch ?? "")
                        }
                        self.searchProductsButton.setTitle("Buscar " + (self.productToSearch ?? ""), for: .normal)
                        self.saveImageResultIfNeeded()
                    }

                }
//            }else{
//                print("No mates found, predicting other objects")
////                //Predict other objects
//                DispatchQueue.global().async {
//                    guard let outputs = self.inferencer.module.detect(image: &pixelBuffer,outputSize: ObjectDetector.output_size) else {
//                        return
//                    }
//
//                    let nmsPredictions = PrePostProcessor.outputsToNMSPredictions(outputs: outputs, outputColumn: ObjectDetector.columns, imgScaleX: imgScaleX, imgScaleY: imgScaleY, ivScaleX: ivScaleX, ivScaleY: ivScaleY, startX: startX, startY: startY)
//
//                    if nmsPredictions.count > 0 {
//                        for prediction in nmsPredictions {
//                            print("Prediccion = Clase: " +  self.inferencer.classes[prediction.classIndex] + " Confianza: " + String(prediction.score))
//                        }
//
//                        DispatchQueue.main.async {
//                            PrePostProcessor.showDetection(imageView: self.takePhotoImageView, nmsPredictions: nmsPredictions, classes: self.inferencer.classes)
//                            for prediction in nmsPredictions {
//                                let predictionWord = self.inferencer.classes[prediction.classIndex]
//                                if let translatedWord = ClassTranslator.translate(word: predictionWord){
//                                    self.productToSearch = translatedWord
//                                    break
//                                }
//                            }
//
//                            if self.productToSearch != "" {
////                                let word = self.inferencer.classes[classIndex]
////                                self.productToSearch = ClassTranslator.translate(word: word)
//                                self.searchProductsButton.isEnabled = true
//                                self.searchProductsButton.setTitle("Buscar " + (self.productToSearch ?? ""), for: .normal)
//                                self.saveImageResultIfNeeded()
//
//                            }else{
//                                let errorViewController = ErrorViewControllerFactory.createErrorViewControllerWithMessage(message: "No se encontraron predicciones para esta imagen")
//                                self.navigationController?.pushViewController(errorViewController, animated: true)
//                            }
//                        }
            }else{
                DispatchQueue.main.async {
                    let errorViewController = ErrorViewControllerFactory.createErrorViewControllerWithMessage(message: "No se encontraron predicciones para esta imagen")
                    self.navigationController?.pushViewController(errorViewController, animated: true)
                }
            }
        }
    }
}
//    }
//}

