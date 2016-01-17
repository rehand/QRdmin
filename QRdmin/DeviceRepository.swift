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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func saveDevice(device: Device, isFavorite: Bool?) {
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName(ENTITY_NAME_DEVICE,
            inManagedObjectContext:managedContext)
        
        let deviceEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        deviceEntity.setValue(device.id, forKey: "id")
        if((isFavorite) != nil){
            deviceEntity.setValue(true, forKey: "isFavorite")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getFavoriteDevices() -> [String] {
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