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
        
        let client = DeviceServerClient()
        
        /*client.retrieve("123"){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }*/
        
        /*client.save(Device(id: "123", name: "My Device", ip: "192.168.0.1", notes: "It's awesome")) {
            (error) -> Void in
            print(error)
        }*/
        
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
        
        NSLog("trying to add device to search index")
        
        // Temporary add test device to Spotlight Index
        DeviceRepository().addDeviceToSearchIndex(Device(id: "1234", name: "Test Device", ip: "127.0.0.1", notes: "Here it is"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tmpShowDetailViewSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            detailViewController.device = Device(id: "test", name: "DeviceName/Title", ip: "8.8.8.8", notes: "this is the notes section. Here you are able to add a description, add changes, etc. You can also use it as an history of done changes.")
        }
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
                if(metadataObj.stringValue.rangeOfString("qrdmin://") != nil)
                {
                    print(metadataObj.stringValue)
                    //TODO: further process deviceID
                }
            }
        }
    }
}
