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
    
    func saveDevice(device: Device, isFavorite: Bool?) {
        let entity =  NSEntityDescription.entityForName(ENTITY_NAME_DEVICE,
            inManagedObjectContext:managedObjectContext)
        
        let deviceEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        deviceEntity.setValue(device.id, forKey: "id")
        deviceEntity.setValue(device.name, forKey: "name")
        deviceEntity.setValue(device.notes, forKey: "comments")
        deviceEntity.setValue(device.ip, forKey: "ipAddress")
        deviceEntity.setValue(NSDate(), forKey: "lastScanned")
        if((isFavorite) != nil){
            deviceEntity.setValue(true, forKey: "isFavorite")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func retrieveAllSavedDevices() -> [Device]{
        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            let managedResults = results as! [NSManagedObject]
            
            var resultList = [Device]()
            for res: NSManagedObject in managedResults {
                let retrievedDevice = Device(id: res.valueForKey("id") as! String, name: res.valueForKey("name") as! String, ip: res.valueForKey("ipAddress") as! String, notes: res.valueForKey("comments") as! String)
                resultList.append(retrievedDevice)
            }
            
            return resultList
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return [Device]()
        }
    }
    
    
    func getFavoriteDevices() -> [String] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        let predicate = NSPredicate(format: "isFavorite IS true")
            
            fetchRequest.predicate = predicate

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let managedResults = results as! [NSManagedObject]
            
            var resultList = [String]()
            for res: NSManagedObject in managedResults {
                resultList.append(String(res.valueForKey("id")))
            }
            
            return resultList
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return [String]()
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
                NSLog("Search item indexed successfully!")
            }
        }
    }
}