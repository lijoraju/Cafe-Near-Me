//
//  FoursquareAPI.swift
//  Cafe-Near-Me
//
//  Created by LIJO RAJU on 08/01/17.
//  Copyright © 2017 LIJORAJU. All rights reserved.
//

import Foundation

class FoursquareAPI {
    static let sharedInstance = FoursquareAPI()
    let session = URLSession.shared
    let date = Date()
    let formatter = DateFormatter()
    
    // MARK: Func searchCafesForALocation
    func searchCafesForALocation(LatitudeAndLongitude LatLon: String, completionHandler: @escaping(_ sucess: Bool, _ errorString: String?)-> Void ) {
        var venueIDs: [String] = []
        var venueNames: [String] = []
        var venueAddresses: [String] = []
        let parameters = [Constants.ParameterKeys.LatLon: LatLon,
                          Constants.ParameterKeys.categoryID: Constants.ParameterValues.categoryID,
                          Constants.ParameterKeys.ClientID: Constants.ParameterValues.ClientID,
                          Constants.ParameterKeys.ClientSecret: Constants.ParameterValues.ClientSecret]
        let request = URLRequest(url: getFoursquareAPIParameters(withAPIPath: Constants.APIPaths.VenuesSearch, withParameters: parameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(false, "No data returned with request")
                return
            }
            var parseResult: Any
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                completionHandler(false, "Couldn't parse to JSON")
                return
            }
            let results = parseResult as AnyObject
            guard let response = results[Constants.ResponseKeys.response] as? [String: AnyObject] else {
                completionHandler(false, "Can't find key '\(Constants.ResponseKeys.response)'")
                return
            }
            guard let venues = response[Constants.ResponseKeys.venues] as? [[String: AnyObject]] else {
                completionHandler(false, "Can't find key '\(Constants.ResponseKeys.venues)'")
                return
            }
            if venues.count == 0 {
                completionHandler(false, "No results")
                return
            }
            for index in 0...venues.count - 1 {
                let venue = venues[index]
                guard let venueName = venue[Constants.ResponseKeys.venueName] else {
                    completionHandler(false, "Can't find key '\(Constants.ResponseKeys.venueName)'")
                    return
                }
                guard let venueId = venue[Constants.ResponseKeys.venueId] else {
                    completionHandler(false, "Can't find key '\(Constants.ResponseKeys.venueId)'")
                    return
                }
                guard let location = venue[Constants.ResponseKeys.venueLocation] as? [String: AnyObject] else {
                    completionHandler(false, "Can't find key '\(Constants.ResponseKeys.venueLocation)'")
                    return
                }
                guard let formattedAddress = location[Constants.ResponseKeys.venueAddress] else {
                    completionHandler(false, "Can't find address")
                    return
                }
                var venueAddress = ""
                for item in (formattedAddress as? NSArray)! {
                    venueAddress = "\(venueAddress) \(item)"
                }
                venueAddresses.append(venueAddress)
                venueIDs.append(venueId as! String)
                venueNames.append(venueName as! String)
            }
            Constants.searchedCafeNames = venueNames
            Constants.searchedCafeIDs = venueIDs
            Constants.searchedCafeAddresses = venueAddresses
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK Func getVenuePhotos
    func getVenuePhotos(selectedVenueID venueID: String, completionHandler: @escaping(_ sucess: Bool, _ error: String?)->Void ) {
       // var venuePhotoURLs: [String] = []
        let parameters = [Constants.ParameterKeys.ClientID: Constants.ParameterValues.ClientID,
                          Constants.ParameterKeys.ClientSecret: Constants.ParameterValues.ClientSecret]
        let APIPath = Constants.APIPaths.Venue + venueID + Constants.APIPaths.Photos
        let request = URLRequest(url: getFoursquareAPIParameters(withAPIPath: APIPath, withParameters: parameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(false, "No data returned with request")
                return
            }
            var parseResult: Any
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                completionHandler(false, "Couldn't parse data as JSON")
                return
            }
            let results = parseResult as AnyObject
            guard let response = results[Constants.ResponseKeys.response] as? [String: AnyObject] else {
                completionHandler(false, "Can't find key \(Constants.ResponseKeys.response)")
                return
            }
            guard let photos = response[Constants.ResponseKeys.photos] as? [String: AnyObject] else {
                completionHandler(false, "Can't find key \(Constants.ResponseKeys.photos)")
                return
            }
            guard let items = photos[Constants.ResponseKeys.items] as? [[String: AnyObject]] else {
                completionHandler(false, "Can't find key\(Constants.ResponseKeys.items)")
                return
            }
            if let photo = items.first {
                let prefix = photo[Constants.ResponseKeys.prefix] as! String
                let suffix = photo[Constants.ResponseKeys.suffix] as! String
                let widthXheight = Constants.ResponseKeys.widthXheight
                let urlString = prefix + widthXheight + suffix
                let url = URL(string: urlString)!
                if let imageData = NSData(contentsOf: url) {
                    Constants.imageData = imageData as Data!
                    print("Downloaded data from url = \(url)")
                }
            }
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: Foursquare API parameters
    func getFoursquareAPIParameters(withAPIPath APIPath: String, withParameters parameters: [String: AnyObject])-> URL {
        var parameters = parameters
        var components = URLComponents()
        components.scheme = Constants.Foursquare.APIScheme
        components.host = Constants.Foursquare.APIHost
        components.path = APIPath
        components.queryItems = [URLQueryItem]()
        formatter.dateFormat = "yyyyMMdd"
        let formatedDate = formatter.string(from: date)
        parameters[Constants.ParameterKeys.version] = formatedDate as AnyObject?
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
}
