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
    
    // MARK: Function searchCafesForALocation
    func searchCafesForALocation(LatitudeAndLongitude LatLon: String, completionHandler: @escaping(_ sucess: Bool, _ errorString: String?)-> Void ) {
        var venueIDs: [String] = []
        var venueNames: [String] = []
        var venueAddresses: [String] = []
        var venueLatitudes: [Double] = []
        var venueLongitudes: [Double] = []
        var venueDistances: [Int] = []
        let parameters = [Constants.ParameterKeys.LatLon: LatLon,
                          Constants.ParameterKeys.categoryID: Constants.ParameterValues.categoryID,
                          Constants.ParameterKeys.radius: Constants.ParameterValues.radius,
                          Constants.ParameterKeys.limit: Constants.ParameterValues.limit,
                          Constants.ParameterKeys.ClientID: Constants.ParameterValues.ClientID,
                          Constants.ParameterKeys.ClientSecret: Constants.ParameterValues.ClientSecret]
        let APIPath = Constants.APIPaths.Venue + Constants.APIPaths.Search
        let request = URLRequest(url: getFoursquareAPIParameters(withAPIPath: APIPath, withParameters: parameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            func reportAnError() {
                completionHandler(false, "Unable to obtain cafes for the location")
            }
            guard let data = data else {
                reportAnError()
                return
            }
            var parseResult: Any
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                reportAnError()
                return
            }
            let results = parseResult as AnyObject
            guard let response = results[Constants.ResponseKeys.response] as? [String: AnyObject] else {
                reportAnError()
                return
            }
            guard let venues = response[Constants.ResponseKeys.venues] as? [[String: AnyObject]] else {
                reportAnError()
                return
            }
            if venues.count == 0 {
                reportAnError()
                return
            }
            for venue in venues {
                guard let venueName = venue[Constants.ResponseKeys.venueName] else {
                    continue
                }
                guard let venueId = venue[Constants.ResponseKeys.venueId] else {
                    continue
                }
                guard let location = venue[Constants.ResponseKeys.venueLocation] as? [String: AnyObject] else {
                    continue
                }
                guard let latitude = location[Constants.ResponseKeys.latitude], let longitude = location[Constants.ResponseKeys.longitude] else {
                    continue
                }
                guard let distance = location[Constants.ResponseKeys.distance] else {
                    return
                }
                guard let formattedAddress = location[Constants.ResponseKeys.venueAddress] else {
                    continue
                }
                var venueAddress = ""
                for item in (formattedAddress as? NSArray)! {
                    venueAddress = "\(venueAddress) \(item)"
                }
                venueLatitudes.append(latitude as! Double)
                venueLongitudes.append(longitude as! Double)
                venueAddresses.append(venueAddress)
                venueIDs.append(venueId as! String)
                venueNames.append(venueName as! String)
                venueDistances.append(distance as! Int)
            }
            Constants.SearchedCafes.Names = venueNames
            Constants.SearchedCafes.VenueIDs = venueIDs
            Constants.SearchedCafes.Addresses = venueAddresses
            Constants.SearchedCafes.Latitudes = venueLatitudes
            Constants.SearchedCafes.Longitudes = venueLongitudes
            Constants.SearchedCafes.Distances = venueDistances
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK Function getVenuePhotos
    func getVenuePhotos(selectedVenueID venueID: String, completionHandler: @escaping(_ sucess: Bool, _ error: String?)->Void ) {
        var venuePhotoURLs: [String] = []
        let parameters = [Constants.ParameterKeys.photosLimit: Constants.ParameterValues.photosLimit,
                          Constants.ParameterKeys.ClientID: Constants.ParameterValues.ClientID,
                          Constants.ParameterKeys.ClientSecret: Constants.ParameterValues.ClientSecret]
        let APIPath = Constants.APIPaths.Venue + venueID + Constants.APIPaths.Photos
        let request = URLRequest(url: getFoursquareAPIParameters(withAPIPath: APIPath, withParameters: parameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(false, "No data returned with get photos request")
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
            for photo in items {
                let prefix = photo[Constants.ResponseKeys.prefix] as! String
                let suffix = photo[Constants.ResponseKeys.suffix] as! String
                let widthXheight = Constants.ResponseKeys.cafePhotowidthXheight
                let urlString = prefix + widthXheight + suffix
                venuePhotoURLs.append(urlString)
            }
            Constants.Cafe.photoURLs = venuePhotoURLs
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: Function getVenueReviews
    func getVenueReviews(selectedVenueID venueID: String, completionHandler: @escaping(_ sucess: Bool, _ error: String?)-> Void) {
        var venueReviews: [String] = []
        var userPhotoURLs: [String] = []
        var userNames: [String] = []
        let parameters = [Constants.ParameterKeys.ClientID: Constants.ParameterValues.ClientID,
                          Constants.ParameterKeys.ClientSecret: Constants.ParameterValues.ClientSecret]
        let APIPath = Constants.APIPaths.Venue + venueID + Constants.APIPaths.Tips
        let request = URLRequest(url: getFoursquareAPIParameters(withAPIPath: APIPath, withParameters: parameters as [String : AnyObject]))
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            func reportAnError() {
                completionHandler(false, "Unable to obtain reviews for this cafe now")
            }
            guard let data = data else {
                reportAnError()
                return
            }
            let parseResult: Any
            do {
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                reportAnError()
                return
            }
            let result = parseResult as AnyObject
            guard let response = result[Constants.ResponseKeys.response] as? [String: AnyObject] else {
                reportAnError()
                return
            }
            guard let tips = response[Constants.ResponseKeys.tips] as? [String: AnyObject] else {
                reportAnError()
                return
            }
            guard let items = tips[Constants.ResponseKeys.items] as? [[String: AnyObject]] else {
                reportAnError()
                return
            }
            for item in items {
                guard let text = item[Constants.ResponseKeys.text] else {
                    continue
                }
                guard let user = item[Constants.ResponseKeys.user] as? [String: AnyObject] else {
                    continue
                }
                guard let firstname = user[Constants.ResponseKeys.firstName], let lastname = user[Constants.ResponseKeys.lastName] else {
                    continue
                }
                guard let photo = user[Constants.ResponseKeys.photo] as? [String: AnyObject] else {
                    continue
                }
                guard let prefix = photo[Constants.ResponseKeys.prefix], let suffix = photo[Constants.ResponseKeys.suffix] else {
                    continue
                }
                let name = (firstname as! String) + " " + (lastname as! String)
                let url = (prefix as! String) + Constants.ResponseKeys.userPhotoWidthxHeight + (suffix as! String)
                venueReviews.append(text as! String)
                userNames.append(name)
                userPhotoURLs.append(url)
            }
            Constants.Cafe.reviews = venueReviews
            Constants.Cafe.reviewerNames = userNames
            Constants.Cafe.reviewerPhotoURLs = userPhotoURLs
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    // MARK: Function downloadImages
    func downloadImages(atImagePath imagePath: String, completionHandler: @escaping(_ imageData: Data?)-> Void) {
        let imageURL = NSURL(string: imagePath)
        let request = NSURLRequest(url: imageURL! as URL)
        let task = session.dataTask(with: request as URLRequest) { data, response, downloadError in
            guard downloadError == nil else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
    // MARK: Function getFoursquareAPIParameters
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
