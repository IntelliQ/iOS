//
//  SettingsViewController.swift
//  intelliQ
//
//  Created by Markus Petrykowski on 27.06.15.
//  Copyright (c) 2015 Markus Petrykowski. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    let defaults = NSUserDefaults(suiteName: "group.me.intelliQ")!
    var nickname = "Anonymous"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = defaults.objectForKey("username") as? String{
            nickname = name
        }
        
        username.text = nickname
    }

    @IBAction func save(sender: UIBarButtonItem) {
        if username.text != ""{
            //Set new username
            defaults.setObject(username.text, forKey: "username")
        }else{
            //Set Anonymus as username
            defaults.setObject("Anonymous", forKey: "username")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
