//
//  DeviceTest.swift
//  QRdmin
//
//  Created by What Ever on 2/3/16.
//  Copyright © 2016 FH Joanneum. All rights reserved.
//

import XCTest

class DeviceTest: XCTestCase {
    
    var device: Device!
    var deviceFromDictionary: Device!
    
    override func setUp() {
        super.setUp()
        
        device = Device(id: "123", name: "TestDevice", ip: "192.168.0.1", notes: "Note")
        
        let dict : [String: String] = ["id": "22", "name": "asd", "ip": "fff", "notes": "ddd"]
        deviceFromDictionary = Device(dict: dict)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContainsSetValues() {
        XCTAssertEqual(device.id, "123")
        XCTAssertEqual(device.name, "TestDevice")
        XCTAssertEqual(device.ip, "192.168.0.1")
        XCTAssertEqual(device.notes, "Note")
    }
    
    func testContainsValuesFromDictionary() {
        XCTAssertEqual(deviceFromDictionary.id, "22")
        XCTAssertEqual(deviceFromDictionary.name, "asd")
        XCTAssertEqual(deviceFromDictionary.ip, "fff")
        XCTAssertEqual(deviceFromDictionary.notes, "ddd")
    }
    
    func testDeviceToDictionary() {
        XCTAssertNotNil(deviceFromDictionary.toDictionary())
    }
    
    func testGetNilForNoImage() {
        XCTAssertNil(device.getUIImage())
    }
    
}
