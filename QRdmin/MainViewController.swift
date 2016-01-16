//
//  MainViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 20/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = DeviceServerClient()
        
        /*client.retrieve("1"){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print(data)
            }
        }*/
        
        /*let params = ["test":2] as Dictionary<String, AnyObject>
        client.save("33", data: params) {
            (error) -> Void in
            print(error)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tmpShowDetailViewSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            detailViewController.device = Device(id: "test", name: "DeviceName/Title", ip: "127.0.0.1", notes: "this is the notes section. Here you are able to add a description, add changes, etc. You can also use it as an history of done changes.")
        }
    } 
}
