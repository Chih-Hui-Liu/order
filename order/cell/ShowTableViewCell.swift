//
//  ShowTableViewCell.swift
//  order
//
//  Created by Leo on 2021/1/14.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    
   
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var largePrice: UILabel!
    @IBOutlet weak var mediumPrice: UILabel!
    @IBOutlet weak var describe: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
