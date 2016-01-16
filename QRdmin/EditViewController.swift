//
//  EditViewController.swift
//  QRdmin
//
//  Created by Reini on 16.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var device : Device?
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldIpAddress: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldName.text = device?.name
        textFieldIpAddress.text = device?.ip
        textViewNotes.text = device?.notes
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "unwindToDetailViewSegue" {
            device?.name = textFieldName.text!
            device?.ip = textFieldIpAddress.text!
            device?.notes = textViewNotes.text
            
            // TODO call to save device on server
        }
    }
    
}
