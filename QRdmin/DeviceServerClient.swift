//
//  DeviceServerClient.swift
//  QRdmin
//
//  Created by What Ever on 1/11/16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

class DeviceServerClient {
    
    var SERVER_IP = "10.0.0.6"
    var SERVER_PORT = "3333"
    
    func retrieve(id: NSString, callback: (Device, String?) -> Void){
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(NSMutableURLRequest(URL: NSURL(string: "http://\(SERVER_IP):\(SERVER_PORT)/device/\(id)")!)) {
            (data, response, error) -> Void in
            if error != nil {
                callback(Device(dict: NSDictionary()), error?.localizedDescription)
            } else {
                let anyObj: AnyObject?
                
                do {
                    anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                    
                    callback(Device(dict: (anyObj)! as! NSDictionary), nil)
                } catch {
                    print("Error occurred during json parse")
                    anyObj = nil
                }
            }
        }
        task.resume()
    }
    
    func save(device: Device, callback: (String?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://\(SERVER_IP):\(SERVER_PORT)/device/\(device.id)")!)
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        do {
            try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(device.toDictionary(), options: NSJSONWritingOptions.init(rawValue: 0))
        } catch {
            print("Error parsing json")
        }
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if error != nil {
                callback(error?.localizedDescription)
            } else {
                callback("OK")
            }
        }
        task.resume()
    }
    
}
