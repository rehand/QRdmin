//
//  DeviceServerClient.swift
//  QRdmin
//
//  Created by What Ever on 1/11/16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

class DeviceServerClient {
   
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if error != nil {
                callback("", error?.localizedDescription)
            } else {
                var result = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
}