//
//  FirstViewController.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 12/8/15.
//  Copyright © 2015 malexcauthen. All rights reserved.
//

import UIKit
import Foundation


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var locationDate: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var mySingleton: Singleton!
    var tmpInputQuestion: TextInput!
    var tmpMultiQuestion: MultiChoice!
    var fileManager = FileManager.default
    var fileHandle: FileHandle!
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        submitButton.layer.cornerRadius = 5.0
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        mySingleton = Singleton.sharedInstance
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        if (mySingleton.title != "") {
            eventName.text = mySingleton.title
        }
        if (mySingleton.location != "") {
            locationDate.text = mySingleton.location + ", " + mySingleton .date
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
/*
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(note:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(note:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
*/
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
/*
    func keyboardWillShow(note: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.tableView.isScrollEnabled = true
        var info = note.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize!.height, 0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(note: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = note.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(-36, 0, -keyboardSize!.height, 0)
        //self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.tableView.isScrollEnabled = true
    }

*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // code for creating tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mySingleton.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (mySingleton.questions[(indexPath as NSIndexPath).row].qType == "TextField"){
            let cell:CustomTextInputCell = tableView.dequeueReusableCell(withIdentifier: "customTextInputCell", for: indexPath) as! CustomTextInputCell
            
            if (mySingleton.questions[(indexPath as NSIndexPath).row].required == 1) {
                cell.firstViewLabel1.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].Label
            } else {
                cell.firstViewLabel1.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].rLabel

            }
            tmpInputQuestion = self.mySingleton.questions[(indexPath as NSIndexPath).row] as! TextInput
            cell.firstViewTextField.placeholder = tmpInputQuestion.placeHolder
            
            if (mySingleton.answers.count < mySingleton.questions.count) {
                mySingleton.answers.append(cell.firstViewTextField)
            }
            
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customMultipleChoiceCell", for: indexPath) as! CustomMultipleChoiceCell
            
            if (mySingleton.questions[(indexPath as NSIndexPath).row].required == 1) {
                cell.firstViewLabel2.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].Label
            } else {
                cell.firstViewLabel2.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].rLabel
            }
            tmpMultiQuestion = self.mySingleton.questions[(indexPath as NSIndexPath).row] as! MultiChoice
            cell.firstViewSegControl.removeAllSegments()
            
            for segment in tmpMultiQuestion.answers {
                cell.firstViewSegControl.insertSegment(withTitle: segment, at: tmpMultiQuestion.answers.count, animated: false)
            }
            
            if (mySingleton.answers.count < mySingleton.questions.count) {
                mySingleton.answers.append(cell.firstViewSegControl)
            }
            
            return cell
        }
    }
    
    @IBAction func submitForm(_ sender: AnyObject) {
        var formData: String = ""
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(mySingleton.filenameCsv)
        let path = fileURL.path
        print(path)
        
        
        var i: Int = 0;
        var questionNotAnswered: Int = 0 // 0 is filled out, 1 is not filled out
        
        for obj in mySingleton.answers {
            if let textfield = obj as? UITextField {
                if (mySingleton.questions[i].required == 0 && textfield.text == "") {
                    textfield.layer.cornerRadius = 5.0
                    textfield.layer.borderWidth = 1
                    textfield.layer.borderColor = UIColor.red.cgColor
                    questionNotAnswered = 1
                }

                else {
                    textfield.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
                    textfield.layer.borderWidth = 1.0
                    textfield.layer.cornerRadius = 5
                    let commaless = textfield.text!.replacingOccurrences(of: ",", with: "/", options: .literal, range: nil)
                    formData = formData + String(format: "%@,", commaless)
                }
                
            }
            
            else if let segcontrol = obj as? UISegmentedControl {
                if (mySingleton.questions[i].required == 0 && segcontrol.selectedSegmentIndex == -1) {
                    segcontrol.tintColor = UIColor.red
                    questionNotAnswered = 1
                }
              
                else {
                    segcontrol.tintColor = UIColor(red: 255.0/255.0, green: 130.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    if (segcontrol.selectedSegmentIndex == -1) {
                        formData = formData + ","
                    } else {
                        formData = formData + String(format: "%@,", segcontrol.titleForSegment(at: segcontrol.selectedSegmentIndex)!)
                    }
                }
            }
            i += 1
        }
        
        if (questionNotAnswered == 0) {
            for obj in mySingleton.answers {
                if let textfield = obj as? UITextField {
                    textfield.text = ""
                }
                
                else if let segcontrol = obj as? UISegmentedControl {
                    segcontrol.selectedSegmentIndex = -1
                }
            }
        }
    
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please fill out the required fields!", preferredStyle: .alert)
        let alertSubmitted = UIAlertController(title: "Submitted", message: "Thank you for your submission!", preferredStyle: .alert)
        let alertNoQuestions = UIAlertController(title: "Usage Error", message: "Nothing to submit!", preferredStyle: .alert)

        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertRequired.addAction(defaultAction)
        alertSubmitted.addAction(defaultAction)
        alertNoQuestions.addAction(defaultAction)
        
        
        if (questionNotAnswered == 0 && mySingleton.answers.count > 0) {
            
            if !fileManager.fileExists(atPath: path) {
                fileManager.createFile(atPath: path, contents: nil, attributes: nil)
                fileHandle = FileHandle(forUpdatingAtPath: path)
                let titleData = String(format: "%@,%@,%@\n", eventName.text!, mySingleton.date, mySingleton.location)
                fileHandle.write(titleData.data(using: String.Encoding.utf8)!)
                
                var columnTitles: String = ""
                for title in mySingleton.questions {
                    columnTitles = columnTitles + String(format: "%@,", title.Label)
                }
                columnTitles = columnTitles + "\n"
                fileHandle.seekToEndOfFile()
                fileHandle.write(columnTitles.data(using: String.Encoding.utf8)!)
            }
            
            formData = formData + "\n"
            fileHandle = FileHandle(forUpdatingAtPath: path)
            fileHandle.seekToEndOfFile()
            fileHandle.write(formData.data(using: String.Encoding.utf8)!)
            fileHandle.closeFile()
            
            present(alertSubmitted, animated: true, completion: nil)
        }
        
        else if (mySingleton.answers.count == 0) {
            present(alertNoQuestions, animated: true, completion: nil)
        }
        
        else {
            present(alertRequired, animated: true, completion: nil)
        }
    }
}

