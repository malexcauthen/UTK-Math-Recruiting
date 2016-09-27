//
//  CustomTextInputCell.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/15/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit

class CustomTextInputCell: UITableViewCell {
    
    
    @IBOutlet weak var firstViewLabel1: UILabel!
    @IBOutlet weak var firstViewTextField: UITextField!
    @IBOutlet weak var secondViewLabel1: UILabel!
    @IBOutlet weak var secondViewTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}