//
//  EditViewController.swift
//  QRdmin
//
//  Created by Reini on 16.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var device : Device?
    
    var imagePicker : UIImagePickerController!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldIpAddress: UITextField!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBAction func changeFavorite(sender: UISwitch) {
        let client = DeviceServerClient()
        let repo = DeviceRepository()
        
        if favoriteSwitch.on {
            print("ON")
            device?.favorite = "true"
            
            client.save(device!) {
                (error) -> Void in
                print(error)
            }
            
            repo.saveDevice(device!, isFavorite: true)
        } else {
            print("OFF")
            device?.favorite = "false"
            
            repo.saveDevice(device!, isFavorite: false)
            
            client.save(device!) {
                (error) -> Void in
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldName.text = device?.name
        textFieldIpAddress.text = device?.ip
        textViewNotes.text = device?.notes
        deviceImageView.image = device?.getUIImage()
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
            
            if deviceImageView.image != nil {
                //Now use image to create into NSData format
                let imageData = UIImagePNGRepresentation(deviceImageView.image!)
                device?.image = imageData!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
            } else {
                device?.image = nil
            }
            
            if device?.favorite == "true" {
                favoriteSwitch.setOn(true, animated: true)
            }
            
            if (device != nil) {
                let client = DeviceServerClient()
                client.save(device!) {
                    (error) -> Void in
                    NSLog("Save: " + error!)
                }
            }
        }
    }
    
    @IBAction func takeImage(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        deviceImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
