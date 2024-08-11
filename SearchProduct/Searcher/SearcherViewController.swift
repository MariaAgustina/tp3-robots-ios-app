//
//  SearcherViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 13/07/2024.
//

import UIKit

final class SearcherViewController: UIViewController {

    var image: UIImage? = nil
    private let predictImageService = PredictImageService()

    @IBOutlet weak var typingLabelView: TypingLabelView!
    @IBOutlet weak var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = BagifyTheme.darkBlue
        loadingView.backgroundColor = UIColor.clear
        loadingView.startAnimating()
        typingLabelView.backgroundColor = UIColor.clear
        if let image = self.image {
            predictImage(image: image)
        }

    }


    func predictImage(image: UIImage) {
        guard let pngData = image.pngData() else {
            return
        }
        let imageData = ProductWithImage(withImage: pngData, andId: "prediction_image")
        predictImageService.predictImage(image: imageData) { [weak self] result in
            switch result {
            case .success(let product):
                print("Service success")
                if let url = URL(string: product.permalink ?? ""){
                    print("url:" + url.absoluteString )
                    UIApplication.shared.open(url)
                }
            case .failure(let error):
                print("Service error" + error.localizedDescription)
            }
        }
    }


}
