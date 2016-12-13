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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFilePaths()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // code for creating tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return txtFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.txtFiles[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilename = txtFiles[(indexPath as NSIndexPath).row]
        documentsPath = documentsPath + "/"
        selectedFilePath = documentsPath + selectedFilename
    }
    
    
    func getFilePaths() {
        documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        print(documentsPath)
        let fileManager = FileManager.default
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: documentsPath)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(".txt") && !txtFiles.contains(element) { // checks the extension
                txtFiles.append(element)
            }
        }
    }

}
