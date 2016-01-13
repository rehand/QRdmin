//
//  DeviceServerClient.swift
//  QRdmin
//
//  Created by What Ever on 1/11/16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

class DeviceServerClient {
    
    func retrieve(id: NSString, callback: (NSDictionary, String?) -> Void){
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(NSMutableURLRequest(URL: NSURL(string: "http://192.168.0.42:3333/select/\(id)")!)) {
            (data, response, error) -> Void in
            if error != nil {
                callback(NSDictionary(), error?.localizedDescription)
            } else {
                let anyObj: AnyObject?
                
                do {
                    anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                } catch {
                    print("Error occurred during json parse")
                    anyObj = nil
                }

                callback((anyObj as? NSDictionary)!, nil)
            }
        }
        task.resume()
    }
    
    func save(id: NSString, data: NSDictionary, callback: (String?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://192.168.0.42:3333/insert/\(id)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        do {
            try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.init(rawValue: 0))
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