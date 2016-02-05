//
//  MainViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //Local variables for QR Reader
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addFavoriteDevicesToSearchIndex()
        
        initializeCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Callback if QR code was detected
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                if(metadataObj.stringValue.rangeOfString("qrdmin://") != nil) {
                    print(metadataObj.stringValue)
                    callDeviceByUrl(metadataObj.stringValue)
                }
            }
        }
    }
    
    func callDeviceByUrl(url: String) {
        let URL_PREFIX : String = "qrdmin://"
        
        var deviceId = url
        if (url.rangeOfString(URL_PREFIX) != nil) {
            deviceId = url.substringFromIndex(deviceId.startIndex.advancedBy(URL_PREFIX.characters.count))
        }
        
        let client = DeviceServerClient()
        client.retrieve(deviceId){
            (device, error) -> Void in
            if (device == nil || error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showCreationViewSegue", sender: deviceId as! AnyObject)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showDetailViewSegue", sender: device as! AnyObject)
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewSegue" {
            let editViewController = segue.destinationViewController as! DetailViewController
            editViewController.device = sender as! Device
        } else if segue.identifier == "showCreationViewSegue" {
            let creationViewController = segue.destinationViewController as! CreationViewController
            creationViewController.deviceId = sender as! String
        }
    }
    
    func addFavoriteDevicesToSearchIndex() {
        let repo = DeviceRepository()
        let favoriteDevices = repo.retrieveAllFavoriteDevices()
        
        for favoriteDevice: Device in favoriteDevices {
            repo.addDeviceToSearchIndex(favoriteDevice)
        }
    }
    
    func initializeCamera() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var input : AVCaptureInput
        do {
            input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer((videoPreviewLayer)!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView?.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView!)
            view.bringSubviewToFront(qrCodeFrameView!)
        }
        catch let error as NSError {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error.localizedDescription)")
        }
    }
}
