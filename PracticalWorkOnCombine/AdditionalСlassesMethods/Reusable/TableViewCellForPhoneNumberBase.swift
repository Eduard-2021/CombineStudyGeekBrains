//
//  TableViewCellForPhoneNumberBase.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 05.02.2022.
//

import UIKit

class TableViewCellForPhoneNumberBase: UITableViewCell {

    @IBOutlet weak var cellWithPhoneNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
