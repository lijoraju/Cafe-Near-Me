//
//  Cafe+CoreDataProperties.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 16/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation
import CoreData

extension Cafe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cafe> {
        return NSFetchRequest<Cafe>(entityName: "Cafe");
    }

    @NSManaged public var address: String?
    @NSManaged public var distance: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var rating: Float
    @NSManaged public var venueID: String?
    @NSManaged public var photos: NSSet?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for photos
extension Cafe {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension Cafe {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
