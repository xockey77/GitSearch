//
//  RepositCell.swift
//  GitSearch
//
//  Created by username on 04.10.2021.
//

import UIKit

class RepositCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var updated_atLabel: UILabel!
    @IBOutlet weak var stargazers_countLabel: UILabel!
    @IBOutlet weak var forks_countLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
