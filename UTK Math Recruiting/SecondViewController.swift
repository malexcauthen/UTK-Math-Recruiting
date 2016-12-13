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
    @IBOutlet weak var filenameTextField: UITextField!
    

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var editButton: UIButton!    
    @IBOutlet weak var editTable: UIButton!
    
    var fileManager = FileManager.default
    var fileHandle: FileHandle!
    
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
        createButton.layer.cornerRadius = 5.0
        editButton.layer.cornerRadius = 5.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleTextField.addTarget(self, action: #selector(SecondViewController.titleTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        dateTextField.addTarget(self, action: #selector(SecondViewController.dateTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        locationTextField.addTarget(self, action: #selector(SecondViewController.locationTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)

        
        mySingleton = Singleton.sharedInstance
        tableView.allowsSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
        tableView.reloadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func titleTextFieldDidChange(_ textfield: UITextField) {
        mySingleton.title = textfield.text!
    }
    
    func dateTextFieldDidChange(_ textfield: UITextField) {
        mySingleton.date = textfield.text!
    }
    
    func locationTextFieldDidChange(_ textfield: UITextField) {
        mySingleton.location = textfield.text!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                cell.secondViewLabel1.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].Label
            } else {
                cell.secondViewLabel1.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].rLabel
            }
            
            tmpInputQuestion = self.mySingleton.questions[(indexPath as NSIndexPath).row] as! TextInput
            cell.secondViewTextField.placeholder = tmpInputQuestion.placeHolder
            
            return cell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customMultipleChoiceCell", for: indexPath) as! CustomMultipleChoiceCell
            
            if (mySingleton.questions[(indexPath as NSIndexPath).row].required == 1) {
                cell.secondViewLabel2.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].Label
            } else {
                cell.secondViewLabel2.text = self.mySingleton.questions[(indexPath as NSIndexPath).row].rLabel
            }
            tmpMultiQuestion = self.mySingleton.questions[(indexPath as NSIndexPath).row] as! MultiChoice
            cell.secondViewSegControl.removeAllSegments()
            
            for segment in tmpMultiQuestion.answers {
                cell.secondViewSegControl.insertSegment(withTitle: segment, at: tmpMultiQuestion.answers.count, animated: false)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = (indexPath as NSIndexPath).row
        mySingleton.indexToEdit = selectedCellIndex
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            mySingleton.questions.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var objectToMove: Question!
        
        if (mySingleton.questions[(sourceIndexPath as NSIndexPath).row].qType == "TextField"){
            objectToMove = mySingleton.questions[sourceIndexPath.row] as! TextInput
        } else {
            objectToMove = mySingleton.questions[sourceIndexPath.row] as! MultiChoice
        }
        
        mySingleton.questions.remove(at: sourceIndexPath.row)
        mySingleton.questions.insert(objectToMove, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
    @IBAction func segueToView(_ sender: AnyObject) {}
    @IBAction func cancelToSecondViewController(_ segue:UIStoryboardSegue) {}
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please select a question to edit!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertRequired.addAction(defaultAction)
        
        if (identifier == "ToEditQuestion") {
            if (mySingleton.indexToEdit == -1) {
                present(alertRequired, animated: true, completion: nil)
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

    
    @IBAction func editQuestion(_ segue:UIStoryboardSegue) {
        if let editQuestion = segue.source as? EditQuestion {
            if (editQuestion.flag == 0) {
                let textinput = editQuestion.newInputQuestion
                mySingleton.questions[mySingleton.indexToEdit] = textinput!
            }
            
            else {
                let multichoice = editQuestion.newMultiQuestion
                mySingleton.questions[mySingleton.indexToEdit] = multichoice!
            }
        }
        mySingleton.indexToEdit = -1 
    }
    
    @IBAction func saveQuestion(_ segue:UIStoryboardSegue) {
        if let CreateQuestion = segue.source as? createQuestion {
            if (CreateQuestion.flag == 0) {
                let textinput = CreateQuestion.newInputQuestion
                mySingleton.questions.append(textinput!)
            }
                
            else {
                let multichoice = CreateQuestion.newMultiQuestion
                mySingleton.questions.append(multichoice!)
            }
            
            let indexPath = IndexPath(row: mySingleton.questions.count-1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func unwindSelectedForm(_ segue:UIStoryboardSegue) {
        if let form = segue.source as? DisplayForms {
            let fileManager = FileManager.default
            
            if(fileManager.fileExists(atPath: form.selectedFilePath))
            {
                print("File exists")
            }
            
            mySingleton.filenameTxt = form.selectedFilename
            filenameTextField.text = mySingleton.filenameTxt
            
            let filename: NSString = mySingleton.filenameTxt as NSString
            let pathPrefix = filename.deletingPathExtension
            mySingleton.filenameCsv = pathPrefix + ".csv" as String
            
            let fileContent = try? NSString(contentsOfFile: form.selectedFilePath, encoding: String.Encoding.utf8.rawValue)
            var fileContentArr = fileContent!.components(separatedBy: "\n")
                        
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
                    } else {
                        req = 1
                    }
                    
                    let label = fileContentArr[index+2]
                    let placeholder = fileContentArr[index+3]
                    let newInputQuestion = TextInput(placeHolder: placeholder, Label: label, rLabel: label + " *", required: req, qType: "TextField")
                    mySingleton.questions.append(newInputQuestion)
                    index += 4
                    
                }
                
                else if (fileContentArr[index] == "MultipleChoice") {
                    var req: Int!
                    
                    if (fileContentArr[index+1] == "Required") {
                        req = 0
                    } else {
                        req = 1
                    }
                    
                    let label = fileContentArr[index+2]
                    let count = Int(fileContentArr[index+3])
                    
                    var answersCount = 0
                    var multiChoiceAnswers = [String]()
                    index += 4
                    
                    while (answersCount < count!) {
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
    
    func handleCancel(_ alert: UIAlertAction) {
        
    }
    
    func writeToFile() {
        var lineSC: String = ""
        
        let alertSubmitted = UIAlertController(title: "Form Saved", message: "The form was saved successfully!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertSubmitted.addAction(defaultAction)
        
        
        mySingleton.title = titleTextField.text!
        mySingleton.date = dateTextField.text!
        mySingleton.location = locationTextField.text!
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(self.mySingleton.filenameTxt)
        let path = fileURL.path
        print(path)
        
        
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        fileHandle = FileHandle(forUpdatingAtPath: path)
        let titleData = String(format: "%@\n%@\n%@\n", self.mySingleton.title, self.mySingleton.location, self.mySingleton.date)
        fileHandle.write(titleData.data(using: String.Encoding.utf8)!)
        
        
        for segment in self.mySingleton.questions {
            var required: String = ""
            if (segment.qType == "TextField") { 
                if let line = segment as? TextInput {
                    if (line.required == 0) {
                        required = "Required"
                        line.Label.remove(at: line.Label.characters.index(before: line.Label.endIndex))
                        line.Label.remove(at: line.Label.characters.index(before: line.Label.endIndex))
                    }
                    else {required = "NRequired"}
                    
                    let lineTF = String(format: "%@\n%@\n%@\n%@\n", line.qType,  required, line.Label, line.placeHolder)
                    fileHandle.write(lineTF.data(using: String.Encoding.utf8)!)
                }
            }
            else {
                if let line = segment as? MultiChoice {
                    if (line.required == 0) {
                        required = "Required"
                        line.Label.remove(at: line.Label.characters.index(before: line.Label.endIndex))
                        line.Label.remove(at: line.Label.characters.index(before: line.Label.endIndex))
                    }
                    else {required = "NRequired"}
                    lineSC = String(format: "%@\n%@\n%@\n", line.qType, required, line.Label)
                    lineSC = lineSC + String(format: "%@\n", String(line.answers.count))
                    for answer in line.answers {
                        lineSC = lineSC + String(format: "%@\n", answer)
                        
                    }
                    
                    fileHandle.write(lineSC.data(using: String.Encoding.utf8)!)
                }
            }
        }
        
        self.present(alertSubmitted, animated: true, completion: nil)
    }



    @IBAction func saveForm(_ sender: AnyObject) {
        let _: UITextField!
        
        let alertRequired = UIAlertController(title: "Usage Error", message: "Please fill out the required fields!", preferredStyle: .alert)
        let alertSave = UIAlertController(title: "Usage Error", message: "Nothing to save!", preferredStyle: .alert)
        let alertFileName = UIAlertController(title: "Please enter a filename", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alertFileName.addTextField { (textField) in
            if self.mySingleton.filenameTxt == "" {
                textField.text = "Please enter a filename."
            } else {
                textField.text = self.mySingleton.filenameTxt
                
                if textField.text?.range(of: ".txt") == nil {
                    textField.text = textField.text! + ".txt"
                }
            }
        }
        
        alertFileName.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let filenameTf = alertFileName.textFields![0] as UITextField // Force unwrapping because we know it exists.
            self.mySingleton.filenameTxt = filenameTf.text!
            self.filenameTextField.text = self.mySingleton.filenameTxt
            
            self.writeToFile()
        }))
        
        // need to figure out the filename stuff.
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertRequired.addAction(defaultAction)
        alertSave.addAction(defaultAction)
        
        var flag: Int = 1;
        if (titleTextField.text == "") {
            titleTextField.layer.borderColor = UIColor.red.cgColor
            titleTextField.layer.cornerRadius = 5.0
            titleTextField.layer.borderWidth = 1
            flag = 0;
        }
       
        if (dateTextField.text == "") {
            dateTextField.layer.borderColor = UIColor.red.cgColor
            dateTextField.layer.cornerRadius = 5.0
            dateTextField.layer.borderWidth = 1
            flag = 0
        }
        
        if (locationTextField.text == "") {
            locationTextField.layer.borderColor = UIColor.red.cgColor
            locationTextField.layer.cornerRadius = 5.0
            locationTextField.layer.borderWidth = 1
            flag = 0
        }
        
        if (mySingleton.questions.count == 0) {
            present(alertSave, animated: true, completion: nil)
            return
        }
        
        if (flag == 0) {
            present(alertRequired, animated: true, completion: nil)
        }
            
        else {
            titleTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            dateTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            locationTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            
            self.present(alertFileName, animated: true, completion: nil)
        }
    }
}




