//
//  ThirdViewController.swift
//  UTK Math Recruiting
//
//  Created by Alex Cauthen on 1/19/16.
//  Copyright © 2016 malexcauthen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ThirdViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var emailButton: UIButton!
    
    var csvFiles: [String] = []
    var selectedFilename: String = ""
    var selectedFilePath: String = ""
    var documentsPath: String = ""
 
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailButton.layer.cornerRadius = 5.0
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
        return csvFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.csvFiles[indexPath.row]
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedFilename = csvFiles[indexPath.row]
        documentsPath = documentsPath + "/"
        selectedFilePath = documentsPath + selectedFilename
    }

    
    func getFilePaths() {
        documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        print(documentsPath)
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(documentsPath)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(".csv") && !csvFiles.contains(element) { // checks the extension
                csvFiles.append(element)
            }
        }
    }
    
    
    @IBAction func sendEmail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["pam"])
        mailComposerVC.setSubject("UTK Recruiting Registration Form")
        let fileData = NSData(contentsOfFile: selectedFilePath)
        mailComposerVC.addAttachmentData(fileData!, mimeType: "text/csv", fileName: selectedFilename)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}