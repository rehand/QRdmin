//
//  Device.swift
//  QRdmin
//
//  Created by Reini on 15.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

class Device : NSObject {
    let id: String
    var name: String
    var ip: String
    var notes: String
    
    init(id: String, name: String, ip: String, notes: String) {
        self.id = id
        self.name = name
        self.ip = ip
        self.notes = notes
    }
    
    init(dict: NSDictionary) {
        self.id = dict.objectForKey("id") as! String
        self.name = dict.objectForKey("name") as! String
        self.ip = dict.objectForKey("ip") as! String
        self.notes = dict.objectForKey("notes") as! String
    }
    
    func toDictionary() -> NSDictionary {
        var dict = [String: String]()
        
        dict["id"] = id
        dict["name"] = name
        dict["ip"] = ip
        dict["notes"] = notes
        
        return NSDictionary(dictionary: dict)
    }

    override  var description: String {
        return "Device: " + self.toDictionary().description
    }
}