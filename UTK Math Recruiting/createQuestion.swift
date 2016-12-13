//
//  createQuestion.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/12/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit

class createQuestion: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet var questionType: UISegmentedControl!
    @IBOutlet var required: UISegmentedControl!
    
    @IBOutlet var inputQuestionTitle: UITextField!
    @IBOutlet var inputQuestionHint: UITextField!
    
    @IBOutlet var multiQuestionTitle: UITextField!
    @IBOutlet var numAnswers: UISegmentedControl!
    @IBOutlet var answerOne: UITextField!
    @IBOutlet var answerTwo: UITextField!
    @IBOutlet var answerThree: UITextField!
    @IBOutlet var answerFour: UITextField!
    
    var numAnswersArray = [UITextField]()
    var newInputQuestion: TextInput!
    var newMultiQuestion: MultiChoice!
    var flag: Int!
    
    
    override func viewDidLoad() {
        numAnswersArray = [answerOne, answerTwo, answerThree, answerFour]
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
        
        
        inputQuestionTitle.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        inputQuestionHint.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        multiQuestionTitle.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerOne.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerTwo.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerThree.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerFour.addTarget(self, action: #selector(createQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)

    }
    
    func textFieldDidChange(_ textfield: UITextField) {
        textfield.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    }
    
    func flagTextField(_ textfield: UITextField) {
        textfield.layer.borderColor = UIColor.red.cgColor
        textfield.layer.cornerRadius = 5.0
        textfield.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please fill out the required fields!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertRequired.addAction(defaultAction)
        
        if (identifier == "SaveQuestion" || identifier == "EditQuestion") {
            if (questionType.selectedSegmentIndex == -1) {
                present(alertRequired, animated: true, completion: nil)
                questionType.tintColor = UIColor.red
                return false
            }
                
            else {
                questionType.tintColor = UIColor(red: 255.0/255.0, green: 130.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            }
            
            if (questionType.selectedSegmentIndex == 0) {
                if (!checkTextFieldQuestion()) {
                    present(alertRequired, animated: true, completion: nil)
                    return false
                }
                
                
                newInputQuestion = TextInput(placeHolder: inputQuestionHint.text!, Label: inputQuestionTitle.text!, rLabel: inputQuestionTitle.text! + " *", required: required.selectedSegmentIndex, qType: "TextField")
                flag = 0
            }
            
            else if (questionType.selectedSegmentIndex == 1) {
                var arrayOfAnswers = [String]()
                
                for i in 0 ..< numAnswers.selectedSegmentIndex + 2 {
                    arrayOfAnswers.append(numAnswersArray[i].text!)
                }
                
                if (!checkSegControlQuestion()) {
                    present(alertRequired, animated: true, completion: nil)
                    return false
                }
                
                newMultiQuestion = MultiChoice(answers: arrayOfAnswers, Label: multiQuestionTitle.text!, rLabel: multiQuestionTitle.text! + " *", required: required.selectedSegmentIndex, qType: "MultipleChoice")
                flag = 1
            }
        }
        
        return true
    }
    
    func checkTextFieldQuestion() -> Bool {
        var flag: Int = 1
        if (inputQuestionTitle.text == "") {
            flagTextField(inputQuestionTitle)
            flag = 0
        }
        
        if (inputQuestionHint.text == "") {
            flagTextField(inputQuestionHint)
            flag = 0
        }
        
        if (flag == 0) {
            return false
        }
        
        return true
    }
    
    func checkSegControlQuestion() -> Bool {
        var flag: Int = 1
        if (multiQuestionTitle.text == "") {
            flagTextField(multiQuestionTitle)
            flag = 0
        }
        
        if (numAnswers.selectedSegmentIndex == -1) {
            numAnswers.tintColor = UIColor.red
            flag = 0
        }
        
        else {
            numAnswers.tintColor = UIColor(red: 255.0/255.0, green: 130.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        
        if (answerOne.isEnabled && answerOne.text == "") {
            flagTextField(answerOne)
            flag = 0
        }
        
        if (answerTwo.isEnabled && answerTwo.text == "") {
            flagTextField(answerTwo)
            flag = 0
        }
        
        if (answerThree.isEnabled && answerThree.text == "") {
            flagTextField(answerThree)
            flag = 0
        }
        
        if (answerFour.isEnabled && answerFour.text == "") {
            flagTextField(answerFour)
            flag = 0
        }
    
        if (flag == 0) {
            return false
        }

        return true
    }
    
    
    func enableTextField(_ textfield: UITextField) {
        textfield.isEnabled = true
        textfield.alpha = 1.0
    }
    
    func enableSegControl(_ segControl: UISegmentedControl) {
        segControl.isEnabled = true
        segControl.alpha = 1.0
    }
    
    func disableTextField(_ textfield: UITextField) {
        textfield.isEnabled = false
        textfield.alpha = 0.0
    }
    
    func disableSegControl(_ segControl: UISegmentedControl) {
        segControl.isEnabled = false
        segControl.alpha = 0.0
    }
    
    
    @IBAction func chooseQuestionType(_ sender: AnyObject) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            disableTextField(multiQuestionTitle)
            disableSegControl(numAnswers)
            
            disableTextField(answerOne)
            disableTextField(answerTwo)
            disableTextField(answerThree)
            disableTextField(answerFour)
            
            enableTextField(inputQuestionTitle)
            enableTextField(inputQuestionHint)
        
        case 1:
            disableTextField(inputQuestionTitle)
            disableTextField(inputQuestionHint)
            
            enableTextField(multiQuestionTitle)
            enableSegControl(numAnswers)
            
        default:
            break
        }
    }
    
    
    @IBAction func chooseNumAnswers(_ sender: AnyObject) {
        switch (sender.selectedSegmentIndex) {
            
        case 0:
            disableTextField(answerThree)
            disableTextField(answerFour)
            
            enableTextField(answerOne)
            enableTextField(answerTwo)
            
        case 1:
            disableTextField(answerFour)
            
            enableTextField(answerOne)
            enableTextField(answerTwo)
            enableTextField(answerThree)
            
        case 2:
            enableTextField(answerOne)
            enableTextField(answerTwo)
            enableTextField(answerThree)
            enableTextField(answerFour)
            
        default:
            break
        }
    }
}
