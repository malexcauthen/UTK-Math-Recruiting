//
//  Question.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/14/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation

class Question {
    var Label: String
    var rLabel: String
    var required: Int
    var qType: String
    
    // create question
    init (Label: String, rLabel: String, required: Int, qType: String) {
        self.Label = Label
        self.rLabel = rLabel
        self.required = required
        self.qType = qType
        
        if (self.required == 0) {
            self.Label = self.Label + " *"
        }
    }
}

class TextInput: Question {
    var placeHolder: String
    
    init (placeHolder: String, Label: String, rLabel: String, required: Int, qType: String) {
        self.placeHolder = placeHolder
        super.init(Label: Label, rLabel: rLabel, required: required, qType: qType)
    }
}

class MultiChoice: Question {
    var answers: [String]
    
    init(answers: [String], Label: String, rLabel: String, required: Int, qType: String) {
        self.answers = answers
        super.init(Label: Label, rLabel: rLabel, required: required, qType: qType)
    }
}
