//
//  ResultsViewController.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    var searchProductService : SearchProductsService!
    var product : String?
    var productsResult : ProductsResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.searchProductService = SearchProductsService()
        searchProducts()

    }
    
    func searchProducts(){
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        guard let product = self.product else{
            return
        }
    
        self.searchProductService.searchProduct(product: product) { productsResult in
            activityIndicator.stopAnimating()
            self.productsResult = productsResult
            self.resultsTableView.reloadData()

        } errorBlock: {
            activityIndicator.stopAnimating()
            //TODO
        }

    }
    
    func setupTableView(){
        self.resultsTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultTableViewCellIdentifier")

    }

}

extension ResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsResult?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultTableViewCellIdentifier", for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        let product = self.productsResult?.results?[indexPath.row]
        
        //this must be in a separate array and not every time a cell is reloaded
        var request = URLRequest(url: URL(string: product?.thumbnail ?? "")!)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.main.async {
                if let data = data {
                    let image = UIImage(data: data)
                    cell.resultImageView?.image = image
                }
            }
        }

        task.resume()

        
        
        cell.titleLabel.text = product?.title
        cell.descriptionLabel.text = "$ " + String(format: "%.2f", product?.price as! CVarArg)
        return cell
    }
    
}
