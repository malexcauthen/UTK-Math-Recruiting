//
//  Singleton.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/16/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation



class Singleton {
    static let sharedInstance = Singleton()
    var questions: [Question] = []
    var answers: [AnyObject] = []
    var filename: String = ""
    var date: String = ""
    var location: String = ""
    var indexToEdit: Int = -1
}