//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Nazik on 22.01.2020.
//  Copyright © 2020 Nazik. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkmarkView: UILabel!
    
    @IBOutlet weak var todoTextLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
