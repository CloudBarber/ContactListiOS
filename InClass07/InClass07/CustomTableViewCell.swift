//
//  CustomTableViewCell.swift
//  InClass07
//
//  Created by Evans, Jonathan on 4/29/19.
//  Copyright © 2019 Evans, Jonathan. All rights reserved.
//

import UIKit

protocol CustomTVCellDelegate{
    func DeleteClicked(cell: UITableViewCell)
    
    
}

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var NameLabel: UILabel!
    
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    
    @IBOutlet weak var PhoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var PhoneTypeLabel: UILabel!
    
    
    var delegate: CustomTVCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func DeleteButton(_ sender: Any) {
        
        print("DeleteButtonClicked")
        delegate?.DeleteClicked(cell: self)
    }
    
    
    
}
