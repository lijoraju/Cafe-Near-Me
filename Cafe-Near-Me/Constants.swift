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
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let ClientID = "YJQD3KYUCHZMMF45FGRXUX5ZK2C5O2R2XJTBDHQN2ABYOLJD"
        static let ClientSecret = "WA43JEE4ZF1AVQPSOIEGZMC2B3JEUFKGVUTLYFDIYFZ3LAIF"
        static let categoryID = "4bf58dd8d48988d16d941735"
    }
    
    // MARK: API Paths
    struct APIPaths {
        static let VenuesSearch = "/v2/venues/search"
    }
    
    // MARK: Response Keys
    struct ResponseKeys {
        static let response = "response"
        static let venues = "venues"
        static let venueName = "name"
        static let venueId = "id"
    }
    
    static var searchingLatLon: String!
    static var searchedCafeNames: [String]!
    static var searchedCafeIDs: [String]!
    static var searchingLocation: String!
    
}
