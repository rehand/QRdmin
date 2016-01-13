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
    
}