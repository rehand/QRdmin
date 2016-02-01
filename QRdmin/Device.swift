//
//  Device.swift
//  QRdmin
//
//  Created by Reini on 15.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation
import UIKit

class Device : NSObject {
    let id: String
    var name: String
    var ip: String
    var notes: String
    var image: String?
    var favorite: String?
    
    convenience init(id: String, name: String, ip: String, notes: String) {
        self.init(id: id, name: name, ip: ip, notes: notes, image: nil, favorite: "false")
    }
    
    init(id: String, name: String, ip: String, notes: String, image: String?, favorite: String) {
        self.id = id
        self.name = name
        self.ip = ip
        self.notes = notes
        self.image = image
        self.favorite = favorite
    }
    
    init(dict: NSDictionary) {
        self.id = dict.objectForKey("id") as! String
        self.name = dict.objectForKey("name") as! String
        self.ip = dict.objectForKey("ip") as! String
        self.notes = dict.objectForKey("notes") as! String
        self.image = dict.objectForKey("image") as? String
        self.favorite = dict.objectForKey("favorite") as? String
    }
    
    func toDictionary() -> NSDictionary {
        var dict = [String: String]()
        
        dict["id"] = id
        dict["name"] = name
        dict["ip"] = ip
        dict["notes"] = notes
        dict["image"] = image
        dict["favorite"] = favorite
        
        return NSDictionary(dictionary: dict)
    }
    
    func getUIImage() -> UIImage? {
        if (self.image != nil) {
            let decodedData = NSData(base64EncodedString: self.image!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            
            if (decodedData != nil) {
                return UIImage(data: decodedData!) as UIImage?
            }
        }
        
        return nil
    }

    override  var description: String {
        return "Device: " + self.toDictionary().description
    }
}