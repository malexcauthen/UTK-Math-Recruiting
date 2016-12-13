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
        return csvFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.csvFiles[(indexPath as NSIndexPath).row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilename = csvFiles[(indexPath as NSIndexPath).row]
        documentsPath = documentsPath + "/"
        selectedFilePath = documentsPath + selectedFilename
    }

    
    func getFilePaths() {
        documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        print(documentsPath)
        let fileManager = FileManager.default
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: documentsPath)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix(".csv") && !csvFiles.contains(element) { // checks the extension
                csvFiles.append(element)
            }
        }
    }
    
    
    @IBAction func sendEmail(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["Pam"])
        mailComposerVC.setSubject("UTK Recruiting Registration Form")
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: selectedFilePath))
        mailComposerVC.addAttachmentData(fileData!, mimeType: "text/csv", fileName: selectedFilename)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
