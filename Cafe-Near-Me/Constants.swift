//
//  Constants.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Foursquare API
    
    struct Foursquare {
        static let APIScheme = "https"
        static let APIHost = "api.foursquare.com"
    }
    
    // MARK: Parameter Keys
    
    struct ParameterKeys {
        static let LatLon = "ll"
        static let ClientID = "client_id"
        static let ClientSecret = "client_secret"
        static let version = "v"
        static let categoryID = "categoryId"
        static let sort = "sort"
        static let radius = "radius"
        static let limit = "limit"
        static let photosLimit = "limit"
    }
    
    // MARK: Parameter Values
    
    struct ParameterValues {
        static let ClientID = "YJQD3KYUCHZMMF45FGRXUX5ZK2C5O2R2XJTBDHQN2ABYOLJD"
        static let ClientSecret = "WA43JEE4ZF1AVQPSOIEGZMC2B3JEUFKGVUTLYFDIYFZ3LAIF"
        static let categoryID = "4bf58dd8d48988d16d941735"
        static let sort = "recent"
        static let radius = "3000"
        static let limit = "50"
        static let photosLimit = "33"
    }
    
    // MARK: API Paths
    
    struct APIPaths {
        static let Search = "search"
        static let Venue = "/v2/venues/"
        static let Photos = "/photos"
        static let Tips = "/tips"
        static let hours = "/hours"
    }
    
    // MARK: Response Keys
    
    struct ResponseKeys {
        static let response = "response"
        static let venues = "venues"
        static let venue = "venue"
        static let venueName = "name"
        static let venueId = "id"
        static let venueLocation = "location"
        static let venueAddress = "formattedAddress"
        static let photos = "photos"
        static let prefix = "prefix"
        static let cafePhotowidthXheight = "375x204"
        static let suffix = "suffix"
        static let items = "items"
        static let tips = "tips"
        static let text = "text"
        static let user = "user"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let photo = "photo"
        static let userPhotoWidthxHeight = "80x80"
        static let latitude = "lat"
        static let longitude = "lng"
        static let distance = "distance"
        static let rating = "rating"
        static let hours = "hours"
        static let timeframes = "timeframes"
        static let includesToday = "includesToday"
        static let open = "open"
        static let start = "start"
        static let end = "end"
    }
    
    // MARK: Searched Cafes
    
    struct SearchedCafes {
        static var Latitudes: [Double]!
        static var Longitudes: [Double]!
        static var Distances: [Int]!
        static var Names: [String]!
        static var VenueIDs: [String]!
        static var Addresses: [String]!
    }
    
    // MARK: Selected Cafe
    
    struct SelectedCafe {
        static var Index: Int!
    }
    
    // MARK: Selected Cafe Reviews
    
    struct Cafe {
        static var rating: Float = 0
        static var openToday: Bool!
        static var openTimeframe: String!
        static var photo: Data!
        static var reviews: [String]!
        static var reviewerNames: [String]!
        static var reviewerPhotoURLs: [String]!
        static var reviewerPhotos: [Data]!
        static var photoURLs: [String]!
        static var photosData: [Data]!
    }
    
    static var searchingLatLon: String!
    static var searchingLocation: String!
    
}
