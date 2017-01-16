//
//  Photo+CoreDataProperties.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 17/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var photoURL: String?
    @NSManaged public var cafe: Cafe?
    @NSManaged public var review: Review?

}
