//
//  DetailViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 28/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var url : NSURL? = nil
    
    var device : Device?
    
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldIpAddress: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
        saveToHistory()
        
        if url != nil {
            NSLog("URL: \(url?.host)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDeviceSegue" {
            let editViewController = segue.destinationViewController as! EditViewController
            editViewController.device = device
        }
    }
    
    @IBAction func unwindFromEditViewController(segue: UIStoryboardSegue){
        self.device = (segue.sourceViewController as! EditViewController).device
        NSLog("unwindFromEditViewController")
        
        initView()
    }
    
    func initView() {
        textFieldName.enabled = false
        textFieldName.text = device?.name
        
        textFieldIpAddress.enabled = false
        textFieldIpAddress.text = device?.ip
        
        textViewNotes.editable = false
        textViewNotes.text = device?.notes
    }
    
    func saveToHistory() {
        let repository = DeviceRepository()
        repository.saveDevice(device!, isFavorite: false)
    }
    
}