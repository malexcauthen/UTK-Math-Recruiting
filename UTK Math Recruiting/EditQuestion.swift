//
//  EditQuestion.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 5/11/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit

class EditQuestion: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var questionType: UISegmentedControl!
    @IBOutlet weak var required: UISegmentedControl!
    
    @IBOutlet weak var inputQuestionTitle: UITextField!
    @IBOutlet weak var inputQuestionHint: UITextField!
    
    @IBOutlet weak var multiQuestionTitle: UITextField!
    @IBOutlet weak var numAnswers: UISegmentedControl!
    @IBOutlet weak var answerOne: UITextField!
    @IBOutlet weak var answerTwo: UITextField!
    @IBOutlet weak var answerThree: UITextField!
    @IBOutlet weak var answerFour: UITextField!
    
    var numAnswersArray = [UITextField]()
    var newInputQuestion: TextInput!
    var newMultiQuestion: MultiChoice!
    var flag: Int!
    var mySingleton: Singleton!
    
    
    override func viewDidLoad() {
        numAnswersArray = [answerOne, answerTwo, answerThree, answerFour]
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
        
        
        inputQuestionTitle.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        inputQuestionHint.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        multiQuestionTitle.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerOne.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerTwo.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerThree.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        answerFour.addTarget(self, action: #selector(EditQuestion.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        mySingleton = Singleton.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (mySingleton.questions[mySingleton.indexToEdit].required == 0) {
            required.selectedSegmentIndex = 0
            mySingleton.questions[mySingleton.indexToEdit].Label.remove(at: mySingleton.questions[mySingleton.indexToEdit].Label.characters.index(before: mySingleton.questions[mySingleton.indexToEdit].Label.endIndex))
            mySingleton.questions[mySingleton.indexToEdit].Label.remove(at: mySingleton.questions[mySingleton.indexToEdit].Label.characters.index(before: mySingleton.questions[mySingleton.indexToEdit].Label.endIndex))
        }
        
        else {
            required.selectedSegmentIndex = 1
        }
        
        if(mySingleton.questions[mySingleton.indexToEdit].qType == "TextField") {
            questionType.selectedSegmentIndex = 0
            chooseQuestionType(questionType)
            if let textfield = mySingleton.questions[mySingleton.indexToEdit] as? TextInput {
                inputQuestionTitle.text = textfield.Label
                inputQuestionHint.text = textfield.placeHolder
            }
        }
        
        else {
            if let segcontrol = mySingleton.questions[mySingleton.indexToEdit] as? MultiChoice {
                questionType.selectedSegmentIndex = 1
                chooseQuestionType(questionType)
                multiQuestionTitle.text = segcontrol.Label
                numAnswers.selectedSegmentIndex = segcontrol.answers.count - 2
                chooseNumAnswers(numAnswers)
                if (numAnswers.selectedSegmentIndex == 0) {
                    answerOne.text = segcontrol.answers[0]
                    answerTwo.text = segcontrol.answers[1]
                }
                
                else if (numAnswers.selectedSegmentIndex == 1) {
                    answerOne.text = segcontrol.answers[0]
                    answerTwo.text = segcontrol.answers[1]
                    answerThree.text = segcontrol.answers[2]
                }
                
                else {
                    answerOne.text = segcontrol.answers[0]
                    answerTwo.text = segcontrol.answers[1]
                    answerThree.text = segcontrol.answers[2]
                    answerFour.text = segcontrol.answers[3]
                }
            }
        }
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
        let alertNotSelected = UIAlertController(title: "Usage Error", message: "Please select a question to edit!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertRequired.addAction(defaultAction)
        alertNotSelected.addAction(defaultAction)
        
        if (mySingleton.indexToEdit == -1) {
            present(alertNotSelected, animated: true, completion: nil)
            return true
        }
        
        if (identifier == "EditQuestion") {
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
        
        else if (identifier == "Cancel") {
            if (mySingleton.questions[mySingleton.indexToEdit].required == 0) {
                mySingleton.questions[mySingleton.indexToEdit].Label = mySingleton.questions[mySingleton.indexToEdit].Label + " *"
            }
            
            return true
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
