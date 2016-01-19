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

class DeviceRepository {
    let ENTITY_NAME_DEVICE = "Device"
    
    func saveDevice(device: Device, isFavorite: Bool?) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Device",
            inManagedObjectContext:managedObjectContext)
        
        let deviceEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        deviceEntity.setValue(device.id, forKey: "id")
        if((isFavorite) != nil){
            deviceEntity.setValue(true, forKey: "isFavorite")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
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
}