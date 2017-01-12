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
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let ClientID = "YJQD3KYUCHZMMF45FGRXUX5ZK2C5O2R2XJTBDHQN2ABYOLJD"
        static let ClientSecret = "WA43JEE4ZF1AVQPSOIEGZMC2B3JEUFKGVUTLYFDIYFZ3LAIF"
        static let categoryID = "4bf58dd8d48988d16d941735"
        static let sort = "recent"
    }
    
    // MARK: API Paths
    struct APIPaths {
        static let Search = "search"
        static let Venue = "/v2/venues/"
        static let Photos = "/photos"
        static let Tips = "/tips"
    }
    
    // MARK: Response Keys
    struct ResponseKeys {
        static let response = "response"
        static let venues = "venues"
        static let venueName = "name"
        static let venueId = "id"
        static let venueLocation = "location"
        static let venueAddress = "formattedAddress"
        static let photos = "photos"
        static let prefix = "prefix"
        static let widthXheight = "375x204"
        static let suffix = "suffix"
        static let items = "items"
        static let tips = "tips"
        static let text = "text"
        static let user = "user"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let photo = "photo"
        static let photoWidthxHeight = "80x80"
        static let latitude = "lat"
        static let longitude = "lng"
    }
    
    // MARK: Searched Cafes
    struct SearchedCafes {
        static var Latitudes: [Double]!
        static var Longitudes: [Double]!
    }
    
    // MARK: Selected Cafe
    struct SelectedCafe {

        
    }
    
    // MARK: Selected Cafe Reviews
    struct SelectedCafeReviews {
        static var reviews: [String]!
        static var userNames: [String]!
        static var userPhotoURLs: [String]!
    }
    
    static var searchingLatLon: String!
    static var searchedCafeNames: [String]!
    static var searchedCafeIDs: [String]!
    static var searchedCafeAddresses: [String]!
    static var searchingLocation: String!
    static var selectedCafeIndex: Int!
    static var imageData: Data!
    
}
