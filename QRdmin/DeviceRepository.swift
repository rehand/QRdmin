//
//  DeviceRepository.swift
//  QRdmin
//
//  Created by Handler Reinhard on 21/10/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

class DeviceRepository {
    let ENTITY_NAME_DEVICE = "Device"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func saveDevice(device: Device, isFavorite: Bool) {
        for existingObject in fetchDeviceNSManagedObjects()! {
            if existingObject.valueForKey("id") as! String == device.id {
                deleteDevice(existingObject)
            }
        }
        
        let entity =  NSEntityDescription.entityForName(ENTITY_NAME_DEVICE,
            inManagedObjectContext:managedObjectContext)
        
        let deviceEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        deviceEntity.setValue(device.id, forKey: "id")
        deviceEntity.setValue(device.name, forKey: "name")
        deviceEntity.setValue(device.notes, forKey: "comments")
        deviceEntity.setValue(device.ip, forKey: "ipAddress")
        deviceEntity.setValue(NSDate(), forKey: "lastScanned")
        if isFavorite {
            deviceEntity.setValue(true, forKey: "isFavorite")
        } else {
            deviceEntity.setValue(false, forKey: "isFavorite")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        if isFavorite {
            addDeviceToSearchIndex(device)
        }
    }
    
    func retrieveAllSavedDevices() -> [Device]{
        var resultList = [Device]()
        for res: NSManagedObject in fetchDeviceNSManagedObjects()! {
            let retrievedDevice = Device(id: res.valueForKey("id") as! String, name: res.valueForKey("name") as! String, ip: res.valueForKey("ipAddress") as! String, notes: res.valueForKey("comments") as! String)
            resultList.append(retrievedDevice)
        }
        
        return resultList
    }
    
    private func fetchDeviceNSManagedObjects() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteDevice(device: NSManagedObject) {
        managedObjectContext.deleteObject(device)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func retrieveAllFavoriteDevices() -> [Device]{
        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            let managedResults = results as! [NSManagedObject]
            
            var resultList = [Device]()
            for res: NSManagedObject in managedResults {
                if res.valueForKey("isFavorite") as! Bool == true {
                    resultList.append(Device(id: res.valueForKey("id") as! String, name: res.valueForKey("name") as! String, ip: res.valueForKey("ipAddress") as! String, notes: res.valueForKey("comments") as! String))
                }
            }
            
            return resultList
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return [Device]()
        }
    }
    
    func addDeviceToSearchIndex(device : Device) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        
        attributeSet.title = device.name
        attributeSet.contentDescription = device.notes
        
        let item = CSSearchableItem(uniqueIdentifier: device.id, domainIdentifier: "qrdmin", attributeSet: attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error: NSError?) -> Void in
            if let error = error {
                NSLog("Indexing error: \(error.localizedDescription)")
            } else {
                NSLog("Added device with ID \(device.id) and name \(device.name) to search index successfully!")
            }
        }
    }
}