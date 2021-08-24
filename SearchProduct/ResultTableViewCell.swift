//
//  ResultTableViewCell.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 23/08/2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
