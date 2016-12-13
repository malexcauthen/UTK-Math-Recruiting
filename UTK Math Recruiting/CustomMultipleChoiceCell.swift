//
//  CustomMultipleChoiceCell.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/15/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit

class CustomMultipleChoiceCell: UITableViewCell {
    
    @IBOutlet weak var firstViewLabel2: UILabel!
    @IBOutlet weak var firstViewSegControl: UISegmentedControl!
    
    @IBOutlet weak var secondViewLabel2: UILabel!
    @IBOutlet weak var secondViewSegControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
