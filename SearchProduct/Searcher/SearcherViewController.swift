//
//  SearcherViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 13/07/2024.
//

import UIKit

final class SearcherViewController: UIViewController {

    var image: UIImage? = nil
//    private let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let predictImageService = PredictImageService()

    @IBOutlet weak var typingLabelView: TypingLabelView!
    @IBOutlet weak var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BagifyTheme.darkBlue
        loadingView.backgroundColor = UIColor.clear
        loadingView.startAnimating()
        typingLabelView.backgroundColor = UIColor.clear
//        typingLabelView.startTypingAnimation(text: "Estamos buscando...", typingSpeed: 0.1)
        if let image = self.image {
            predictImage(image: image)
        }

    }


    func predictImage(image: UIImage) {
        guard let pngData = image.pngData() else {
            return
        }
        let imageData = ProductWithImage(withImage: pngData, andId: "prediction_image")
//        activityIndicatorView?.startAnimating()
        predictImageService.predictImage(image: imageData) { [weak self] result in
            switch result {
            case .success(let product):
                print("Service success")
                if let url = URL(string: product.permalink ?? ""){
                    print("url:" + url.absoluteString )
                    UIApplication.shared.open(url)
//                    self?.activityIndicatorView?.stopAnimating()
                }
            case .failure(let error):
                print("Service error" + error.localizedDescription)
            }
        }
    }


}
