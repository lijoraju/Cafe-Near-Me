//
//  CoreData.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 16/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import CoreData

class CoreData {
    static let sharedInstance = CoreData()
    
    // MARK: Function gettingCafeInfo(managedObjectContext context: NSManagedObjectContext)-> Cafe
    func gettingCafeInfo(managedObjectContext context: NSManagedObjectContext)-> Cafe {
        let fetchRequest: NSFetchRequest<Cafe> = Cafe.fetchRequest()
        var cafes: [Cafe] = []
        do {
            cafes = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Unable to fetch \(error) \(error.userInfo)")
        }
        let cafeIndex = (Constants.SelectedCafe.Index)!
        let cafe = cafes[cafeIndex]
        return cafe
    }
    
    // MARK: Function save(managedObjectContext context: NSManagedObjectContext, completionHandler: @escaping(_ sucess: Bool)-> void)
    func save(managedObjectContext context: NSManagedObjectContext, completionHandler: @escaping(_ sucess: Bool)-> Void) {
        do {
            try context.save()
            completionHandler(true)
        }
        catch let error as NSError {
            print("Error Occured:\(error) \(error.userInfo)")
            completionHandler(false)
        }
    }
    
}
