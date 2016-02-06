//
//  DetailViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 28/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import CoreData

// this class shows details for a device
class DetailViewController: UIViewController {
    
    var device : Device?
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldIpAddress: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(self.navigationController != nil) {
            for var i = 0 ; i < self.navigationController!.viewControllers.count ; i++
            {
                if(self.navigationController!.viewControllers[i] is CreationViewController)
                {
                    self.navigationController!.viewControllers.removeAtIndex(i)
                }
            }
        }
        
        initView()
        saveToHistory()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDeviceSegue" {
            let editViewController = segue.destinationViewController as! EditViewController
            editViewController.device = device
        } else if segue.identifier == "pingDeviceSegue" {
            let pingAnimationViewController = segue.destinationViewController as! PingAnimationViewController
            pingAnimationViewController.device = device
        }
    }
    
    @IBAction func unwindFromEditViewController(segue: UIStoryboardSegue){
        self.device = (segue.sourceViewController as! EditViewController).device
        initView()
    }
    
    func initView() {
        textFieldName.enabled = false
        textFieldName.text = device?.name
        
        textFieldIpAddress.enabled = false
        textFieldIpAddress.text = device?.ip
        
        textViewNotes.editable = false
        textViewNotes.text = device?.notes
        
        deviceImageView.image = device?.getUIImage()
        
        if device?.favorite == "true" {
            favoriteSwitch.setOn(true, animated: true)
        }
    }
    
    func saveToHistory() {
        let repository = DeviceRepository()
        repository.saveDevice(device!, isFavorite: device?.favorite == "true")
    }
    
}
