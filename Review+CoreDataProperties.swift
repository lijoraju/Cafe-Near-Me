//
//  Review+CoreDataProperties.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 16/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import CoreData
import 

extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review");
    }

    @NSManaged public var review: String?
    @NSManaged public var reviewer: String?
    @NSManaged public var photo: Photo?
    @NSManaged public var cafe: Cafe?

}
