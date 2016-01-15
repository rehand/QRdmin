//
//  Device.swift
//  QRdmin
//
//  Created by Reini on 15.01.16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import Foundation

class Device {
    let id: String
    let name: String
    let ip: String
    let description: String
    
    init(id: String, name: String, ip: String, description: String) {
        self.id = id
        self.name = name
        self.ip = ip
        self.description = description
    }
}