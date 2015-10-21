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
    
    let appDelegate =
    UIApplication.sharedApplication().delegate as! AppDelegate
    
    func saveDevice(deviceAsJSON: String) {
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName(ENTITY_NAME_DEVICE,
            inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        // TODO: parse JSON
        
        //3
        //person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            //people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getFavoriteDevices() {
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: ENTITY_NAME_DEVICE)
        
        let predicate = NSPredicate(format: "isFavorite IS true")
            
            fetchRequest.predicate = predicate
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            //people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}