//
//  DisplayForms.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 3/2/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit


class DisplayForms: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var txtFiles: [String] = []
    var selectedFilename: String = ""
    var selectedFilePath: String = ""
    var documentsPath: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getFilePaths()
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // code for creating tableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return txtFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.txtFiles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedFilename = txtFiles[indexPath.row]
        documentsPath = documentsPath + "/"
        selectedFilePath = documentsPath + selectedFilename
    }
    
    
    func getFilePaths() {
        documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        print(documentsPath)
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(documentsPath)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(".txt") && !txtFiles.contains(element) { // checks the extension
                txtFiles.append(element)
            }
        }
    }

}