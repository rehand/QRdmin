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
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func saveDevice(device: Device, isFavorite: Bool?) {
        let entity =  NSEntityDescription.entityForName(ENTITY_NAME_DEVICE,
            inManagedObjectContext:managedObjectContext)
        
        let deviceEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        deviceEntity.setValue(device.id, forKey: "id")
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
    
    func retrieveAllSavedDevices() -> [String]{
        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            let managedResults = results as! [NSManagedObject]
            
            var resultList = [String]()
            for res: NSManagedObject in managedResults {
                let id = res.valueForKey("id")
                let scanned = res.valueForKey("lastScanned")
                resultList.append("\(id!), \(scanned!)")
            }
            
            return resultList
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return [String]()
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