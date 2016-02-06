//
//  CreationViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 06/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    var deviceId : String?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldIpAddress: UITextField!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var textViewNotes: UITextView!
    @IBOutlet weak var createFavoriteSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(300, 1000)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "createDeviceSegue" {
            let device = Device(id: deviceId!,
                                name: textFieldName.text!,
                ip: textFieldIpAddress.text!,
                notes: textViewNotes.text)
            
            if deviceImageView.image != nil {
                //Now use image to create into NSData format
                let imageData = UIImagePNGRepresentation(deviceImageView.image!)
                device.image = imageData!.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
            } else {
                device.image = nil
            }
            
            if (createFavoriteSwitch.on) {
                device.favorite = "true"
            } else {
                device.favorite = "false"
            }
            
            if (deviceId != nil) {
                let client = DeviceServerClient()
                client.save(device) {
                    (error) -> Void in
                    NSLog("Save: " + error!)
                }
                
                let repo = DeviceRepository()
                repo.saveDevice(device, isFavorite: device.favorite == "true")
            }
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.device = device
        }
    }
    
    @IBAction func takeImage(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        deviceImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}
