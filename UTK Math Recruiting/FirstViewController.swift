//
//  FirstViewController.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 12/8/15.
//  Copyright © 2015 malexcauthen. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var locationDate: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var mySingleton: Singleton!
    var tmpInputQuestion: TextInput!
    var tmpMultiQuestion: MultiChoice!
    var fileManager = NSFileManager.defaultManager()
    var fileHandle: NSFileHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        submitButton.layer.cornerRadius = 5.0
        tableView.delegate = self
        tableView.dataSource = self
        mySingleton = Singleton.sharedInstance
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        if (mySingleton.filename != "") {
            eventName.text = mySingleton.filename
        }
        if (mySingleton.location != "") {
            locationDate.text = mySingleton.location + ", " + mySingleton.date
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // code for creating tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mySingleton.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (mySingleton.questions[indexPath.row].qType == "TextField"){
            let cell:CustomTextInputCell = tableView.dequeueReusableCellWithIdentifier("customTextInputCell", forIndexPath: indexPath) as! CustomTextInputCell
            
            if (mySingleton.questions[indexPath.row].required == 1) {
                cell.firstViewLabel1.text = self.mySingleton.questions[indexPath.row].Label
            } else {
                cell.firstViewLabel1.text = self.mySingleton.questions[indexPath.row].rLabel

            }
            tmpInputQuestion = self.mySingleton.questions[indexPath.row] as! TextInput
            cell.firstViewTextField.placeholder = tmpInputQuestion.placeHolder
            
            if (mySingleton.answers.count < mySingleton.questions.count) {
                mySingleton.answers.append(cell.firstViewTextField)
            }
            
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("customMultipleChoiceCell", forIndexPath: indexPath) as! CustomMultipleChoiceCell
            
            if (mySingleton.questions[indexPath.row].required == 1) {
                cell.firstViewLabel2.text = self.mySingleton.questions[indexPath.row].Label
            } else {
                cell.firstViewLabel2.text = self.mySingleton.questions[indexPath.row].rLabel
            }
            tmpMultiQuestion = self.mySingleton.questions[indexPath.row] as! MultiChoice
            cell.firstViewSegControl.removeAllSegments()
            
            for segment in tmpMultiQuestion.answers {
                cell.firstViewSegControl.insertSegmentWithTitle(segment, atIndex: tmpMultiQuestion.answers.count, animated: false)
            }
            
            if (mySingleton.answers.count < mySingleton.questions.count) {
                mySingleton.answers.append(cell.firstViewSegControl)
            }
            
            return cell
        }
    }
    
    @IBAction func submitForm(sender: AnyObject) {
        var formData: String = ""
        
        if (!mySingleton.filename.hasSuffix(".csv")) {
            mySingleton.filename = mySingleton.filename + ".csv"
        }
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(mySingleton.filename)
        let path = fileURL.path
        print(path)
        
        
        var i: Int = 0;
        var questionNotAnswered: Int = 0 // 0 is filled out, 1 is not filled out
        
        for obj in mySingleton.answers {
            if let textfield = obj as? UITextField {
                if (mySingleton.questions[i].required == 0 && textfield.text == "") {
                    textfield.layer.cornerRadius = 5.0
                    textfield.layer.borderWidth = 1
                    textfield.layer.borderColor = UIColor.redColor().CGColor
                    questionNotAnswered = 1
                }

                else {
                    textfield.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
                    textfield.layer.borderWidth = 1.0
                    textfield.layer.cornerRadius = 5
                    formData = formData + String(format: "%@,", textfield.text!)
                }
                
            }
            
            else if let segcontrol = obj as? UISegmentedControl {
                if (mySingleton.questions[i].required == 0 && segcontrol.selectedSegmentIndex == -1) {
                    segcontrol.tintColor = UIColor.redColor()
                    questionNotAnswered = 1
                }
              
                else {
                    segcontrol.tintColor = UIColor(red: 255.0/255.0, green: 130.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    if (segcontrol.selectedSegmentIndex == -1) {
                        formData = formData + ","
                    } else {
                        formData = formData + String(format: "%@,", segcontrol.titleForSegmentAtIndex(segcontrol.selectedSegmentIndex)!)
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
    
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please fill out the required fields!", preferredStyle: .Alert)
        let alertSubmitted = UIAlertController(title: "Submitted", message: "Thank you for your submission!", preferredStyle: .Alert)
        let alertNoQuestions = UIAlertController(title: "Usage Error", message: "Nothing to submit!", preferredStyle: .Alert)

        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertRequired.addAction(defaultAction)
        alertSubmitted.addAction(defaultAction)
        alertNoQuestions.addAction(defaultAction)
        
        
        if (questionNotAnswered == 0 && mySingleton.answers.count > 0) {
            
            if !fileManager.fileExistsAtPath(path!) {
                fileManager.createFileAtPath(path!, contents: nil, attributes: nil)
                fileHandle = NSFileHandle(forUpdatingAtPath: path!)
                let titleData = String(format: "%@,%@,%@\n", eventName.text!, mySingleton.date, mySingleton.location)
                fileHandle.writeData(titleData.dataUsingEncoding(NSUTF8StringEncoding)!)
                
                var columnTitles: String = ""
                for title in mySingleton.questions {
                    columnTitles = columnTitles + String(format: "%@,", title.Label)
                }
                columnTitles = columnTitles + "\n"
                fileHandle.seekToEndOfFile()
                fileHandle.writeData(columnTitles.dataUsingEncoding(NSUTF8StringEncoding)!)
            }
            
            formData = formData + "\n"
            fileHandle = NSFileHandle(forUpdatingAtPath: path!)
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(formData.dataUsingEncoding(NSUTF8StringEncoding)!)
            fileHandle.closeFile()
            
            presentViewController(alertSubmitted, animated: true, completion: nil)
        }
        
        else if (mySingleton.answers.count == 0) {
            presentViewController(alertNoQuestions, animated: true, completion: nil)
        }
        
        else {
            presentViewController(alertRequired, animated: true, completion: nil)
        }
    }
}

