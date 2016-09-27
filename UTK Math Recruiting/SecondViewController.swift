//
//  SecondViewController.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 12/8/15.
//  Copyright © 2015 malexcauthen. All rights reserved.
//

import Foundation
import UIKit



class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var typeSegControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var editButton: UIButton!    
    
    var fileManager = NSFileManager.defaultManager()
    var fileHandle: NSFileHandle!
    
    var textinput: TextInput!
    var multichoice: MultiChoice!
    var flag: Int!
    var type: Int!
    var tmpInputQuestion: TextInput!
    var tmpMultiQuestion: MultiChoice!
    var mySingleton: Singleton!
    var selectedCellIndex: Int!
    var filename: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        selectButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
        deleteButton.layer.cornerRadius = 5.0
        createButton.layer.cornerRadius = 5.0
        editButton.layer.cornerRadius = 5.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleTextField.addTarget(self, action: #selector(SecondViewController.titleTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        dateTextField.addTarget(self, action: #selector(SecondViewController.dateTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        locationTextField.addTarget(self, action: #selector(SecondViewController.locationTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)

        
        mySingleton = Singleton.sharedInstance
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func titleTextFieldDidChange(textfield: UITextField) {
        mySingleton.filename = textfield.text!
    }
    
    func dateTextFieldDidChange(textfield: UITextField) {
        mySingleton.date = textfield.text!
    }
    
    func locationTextFieldDidChange(textfield: UITextField) {
        mySingleton.location = textfield.text!
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
                cell.secondViewLabel1.text = self.mySingleton.questions[indexPath.row].Label
            } else {
                cell.secondViewLabel1.text = self.mySingleton.questions[indexPath.row].rLabel
            }
            
            tmpInputQuestion = self.mySingleton.questions[indexPath.row] as! TextInput
            cell.secondViewTextField.placeholder = tmpInputQuestion.placeHolder
            
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("customMultipleChoiceCell", forIndexPath: indexPath) as! CustomMultipleChoiceCell
            
            if (mySingleton.questions[indexPath.row].required == 1) {
                cell.secondViewLabel2.text = self.mySingleton.questions[indexPath.row].Label
            } else {
                cell.secondViewLabel2.text = self.mySingleton.questions[indexPath.row].rLabel
            }
            tmpMultiQuestion = self.mySingleton.questions[indexPath.row] as! MultiChoice
            cell.secondViewSegControl.removeAllSegments()
            
            for segment in tmpMultiQuestion.answers {
                cell.secondViewSegControl.insertSegmentWithTitle(segment, atIndex: tmpMultiQuestion.answers.count, animated: false)
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCellIndex = indexPath.row
        mySingleton.indexToEdit = selectedCellIndex
    }
    
    
    @IBAction func segueToView(sender: AnyObject) {}
    @IBAction func cancelToSecondViewController(segue:UIStoryboardSegue) {}
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please select a question to edit!", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

        alertRequired.addAction(defaultAction)
        
        if (identifier == "ToEditQuestion") {
            if (mySingleton.indexToEdit == -1) {
                presentViewController(alertRequired, animated: true, completion: nil)
                return false
            }
            
            return true
        }
        
        else if (identifier == "SelectForm") {
            return true
        }
        
        else if (identifier == "CreateQuestion") {
            return true
        }
        
        return true
    }

    
    @IBAction func editQuestion(segue:UIStoryboardSegue) {
        if let editQuestion = segue.sourceViewController as? EditQuestion {
            if (editQuestion.flag == 0) {
                let textinput = editQuestion.newInputQuestion
                mySingleton.questions[mySingleton.indexToEdit] = textinput
            }
            
            else {
                let multichoice = editQuestion.newMultiQuestion
                mySingleton.questions[mySingleton.indexToEdit] = multichoice
            }
        }
        mySingleton.indexToEdit = -1 
    }
    
    @IBAction func saveQuestion(segue:UIStoryboardSegue) {
        if let CreateQuestion = segue.sourceViewController as? createQuestion {
            if (CreateQuestion.flag == 0) {
                let textinput = CreateQuestion.newInputQuestion
                mySingleton.questions.append(textinput)
            }
                
            else {
                let multichoice = CreateQuestion.newMultiQuestion
                mySingleton.questions.append(multichoice)
            }
            
            let indexPath = NSIndexPath(forRow: mySingleton.questions.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func unwindSelectedForm(segue:UIStoryboardSegue) {
        if let form = segue.sourceViewController as? DisplayForms {
            let fileManager = NSFileManager.defaultManager()
            
            if(fileManager.fileExistsAtPath(form.selectedFilePath))
            {
                print("File exists")
            }
            
            let fileContent = try? NSString(contentsOfFile: form.selectedFilePath, encoding: NSUTF8StringEncoding)
            var fileContentArr = fileContent!.componentsSeparatedByString("\n")
                        
            var index: Int = 0;
            
            while(index < fileContentArr.count) {
                if (index == 0) {
                    
                    mySingleton.questions.removeAll()
                    titleTextField.text = fileContentArr[index]
                    locationTextField.text = fileContentArr[index+1]
                    dateTextField.text = fileContentArr[index+2]
                    index += 3
                }
                
                else if (fileContentArr[index] == "TextField") {
                    
                    var req: Int!
                    if (fileContentArr[index+1] == "Required") {
                        req = 0
                    }
                    
                    else {
                        req = 1
                    }
                    
                    let label = fileContentArr[index+2]
                    print(label)
                    let placeholder = fileContentArr[index+3]
                    let newInputQuestion = TextInput(placeHolder: placeholder, Label: label, rLabel: label + " *", required: req, qType: "TextField")
                    mySingleton.questions.append(newInputQuestion)
                    index += 4
                    
                }
                
                else if (fileContentArr[index] == "MultipleChoice") {
                    var req: Int!
                    if (fileContentArr[index+1] == "Required") {
                        req = 0
                    }
                        
                    else {
                        req = 1
                    }
                    
                    let label = fileContentArr[index+2]
                    print(label)
                    let count = Int(fileContentArr[index+3])
                    
                    var answersCount = 0
                    var multiChoiceAnswers = [String]()
                    index += 4
                    
                    while (answersCount < count) {
                        multiChoiceAnswers.append(fileContentArr[index + answersCount])
                        answersCount += 1
                    }
                    
                    let newMultiChoice = MultiChoice(answers: multiChoiceAnswers, Label: label, rLabel: label + " *", required: req, qType: "MultipleChoice")
                    mySingleton.questions.append(newMultiChoice)
                    index += answersCount
                }
                
                else {
                    break;
                }
            }
            
            titleTextFieldDidChange(titleTextField)
            dateTextFieldDidChange(dateTextField)
            locationTextFieldDidChange(locationTextField)
        }
    }
    
    func handleCancel(alert: UIAlertAction) {
        
    }
    
    
    @IBAction func saveForm(sender: AnyObject) {
        var lineSC: String = ""
        
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please fill out the required fields!", preferredStyle: .Alert)
        let alertSave = UIAlertController(title: "Usage Error", message: "Nothing to save!", preferredStyle: .Alert)
        let alertSubmitted = UIAlertController(title: "Form Saved", message: "The form was saved successfully!", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertRequired.addAction(defaultAction)
        alertSubmitted.addAction(defaultAction)
        alertSave.addAction(defaultAction)
        
        var flag: Int = 1;
        if (titleTextField.text == "") {
            titleTextField.layer.borderColor = UIColor.redColor().CGColor
            titleTextField.layer.cornerRadius = 5.0
            titleTextField.layer.borderWidth = 1
            flag = 0;
        }
       
        if (dateTextField.text == "") {
            dateTextField.layer.borderColor = UIColor.redColor().CGColor
            dateTextField.layer.cornerRadius = 5.0
            dateTextField.layer.borderWidth = 1
            flag = 0
        }
        
        if (locationTextField.text == "") {
            locationTextField.layer.borderColor = UIColor.redColor().CGColor
            locationTextField.layer.cornerRadius = 5.0
            locationTextField.layer.borderWidth = 1
            flag = 0
        }
        
        if (mySingleton.questions.count == 0) {
            presentViewController(alertSave, animated: true, completion: nil)
            return
        }
        
        if (flag == 0) {
            presentViewController(alertRequired, animated: true, completion: nil)
        }
            
        else {
            titleTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            dateTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            locationTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            
            mySingleton.filename = titleTextField.text!
            mySingleton.date = dateTextField.text!
            mySingleton.location = locationTextField.text!
            
            if (!titleTextField.text!.hasSuffix(".txt")) {
                filename = titleTextField.text! + ".txt"
            }
            
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileURL = documentsURL.URLByAppendingPathComponent(filename)
            let path = fileURL.path
            print(path)
            
            fileManager.createFileAtPath(path!, contents: nil, attributes: nil)
            fileHandle = NSFileHandle(forUpdatingAtPath: path!)
            let titleData = String(format: "%@\n%@\n%@\n", mySingleton.filename, mySingleton.location, mySingleton.date)
            fileHandle.writeData(titleData.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            for segment in mySingleton.questions {
                var required: String = ""
                if (segment.qType == "TextField") {
                    if let line = segment as? TextInput {
                        if (line.required == 0) {
                            required = "Required"
                            line.Label.removeAtIndex(line.Label.endIndex.predecessor())
                            line.Label.removeAtIndex(line.Label.endIndex.predecessor())
                        }
                        else {required = "NRequired"}
                        
                        let lineTF = String(format: "%@\n%@\n%@\n%@\n", line.qType,  required, line.Label, line.placeHolder)
                        fileHandle.writeData(lineTF.dataUsingEncoding(NSUTF8StringEncoding)!)
                    }
                }
                else {
                    if let line = segment as? MultiChoice {
                        if (line.required == 0) {
                            required = "Required"
                            line.Label.removeAtIndex(line.Label.endIndex.predecessor())
                            line.Label.removeAtIndex(line.Label.endIndex.predecessor())
                        }
                        else {required = "NRequired"}
                        lineSC = String(format: "%@\n%@\n%@\n", line.qType, required, line.Label)
                        lineSC = lineSC + String(format: "%@\n", String(line.answers.count))
                        for answer in line.answers {
                            lineSC = lineSC + String(format: "%@\n", answer)
                            
                        }
                        
                        fileHandle.writeData(lineSC.dataUsingEncoding(NSUTF8StringEncoding)!)
                    }
                }
            }
            presentViewController(alertSubmitted, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func deleteQuestion(sender: AnyObject) {
        
        if (selectedCellIndex == nil) {
            let alertRequired = UIAlertController(title: "Usage Error", message: "Please select a question to delete", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertRequired.addAction(defaultAction)
            presentViewController(alertRequired, animated: true, completion: nil)

        }
        
        else if (mySingleton.questions.count >  0) {
            mySingleton.questions.removeAtIndex(selectedCellIndex)
            tableView.reloadData()
        }
        
        selectedCellIndex = nil
    }
    
}




