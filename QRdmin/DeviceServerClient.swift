//
//  DeviceServerClient.swift
//  QRdmin
//
//  Created by What Ever on 1/11/16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

// this class handles the webservice calls
class DeviceServerClient {
    
    var SERVER_IP = ""
    var SERVER_PORT = ""
    
    // timeout for requests in seconds
    var REQUEST_TIMEOUT = 10.0
 
    init() {
        if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) {
            SERVER_IP = dict.valueForKey("ServerIP") as! String
            SERVER_PORT = dict.valueForKey("ServerPort") as! String
        }
    }
    
    func retrieve(id: NSString, callback: (Device?, String?) -> Void){
        NSLog("trying to retrieve device with id \(id)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(NSMutableURLRequest(URL: NSURL(string: "http://\(SERVER_IP):\(SERVER_PORT)/device/\(id)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: NSTimeInterval(REQUEST_TIMEOUT))) {
            (data, response, error) -> Void in
            if error != nil {
                callback(nil, error?.localizedDescription)
            } else {
                let anyObj: AnyObject?
                
                do {
                    anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                    callback(Device(dict: (anyObj)! as! NSDictionary), nil)
                } catch {
                    print("Error occurred during json parse")
                    callback(nil, "error parsing JSON")
                }
            }
        }
        task.resume()
    }
    
    func save(device: Device, callback: (String?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://\(SERVER_IP):\(SERVER_PORT)/device/\(device.id)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: NSTimeInterval(REQUEST_TIMEOUT))
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
