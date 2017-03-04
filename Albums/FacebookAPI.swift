//
//  FacebookAPI.swift
//  SoldecTest
//
//  Created by Mikhail Kulichkov on 25/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

struct FacebookAPI {
    static let shared = FacebookAPI()
    private let urlSession = URLSession(configuration: .default)

    func share(sender: UIViewController!) {
        let fbPhoto = (sender as! FullPhotoViewController).photo!
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentURL = URL(string: fbPhoto.link)
        FBSDKShareDialog.show(from: sender, with: shareContent, delegate: nil)
    }

    func fetchAlbums(pageCursor: String?, complete: @escaping (_ albums: [FBAlbum], _ nextPage: String?) -> ()) {
        var parameters = ["fields": "name,id,cover_photo"]
        if pageCursor != nil {
            parameters.updateValue(pageCursor!, forKey: "after")
        }
        FBSDKGraphRequest(graphPath: "/me/albums", parameters: parameters).start { (_, result, _) in
            if let parsedResult = result as? [String: Any] {
                var albums = [FBAlbum]()
                var nextPage: String?
                if let data = parsedResult["data"] as? [[String: Any]] {
                    for eachAlbum in data {
                        let id = eachAlbum["id"] as? String ?? Constants.stringBlank
                        let name = eachAlbum["name"] as? String ?? Constants.stringBlank
                        var coverId = Constants.stringBlank
                        if let cover_photo = eachAlbum["cover_photo"] as? [String: String] {
                            coverId = cover_photo["id"] ?? Constants.stringBlank
                        }
                        let album = FBAlbum(id: id, name: name, coverId: coverId, photos: [FBPhoto]())
                        albums.append(album)
                    }
                }
                if let paging = parsedResult["paging"] as? [String: Any] {
                    if let cursors = paging["cursors"] as? [String: String] {
                        if let after = cursors["after"] {
                            nextPage = after
                        }
                    }
                }
                complete(albums, nextPage)
            }
        }
    }

    func fetchPhotos(albumId: String, pageCursor: String?, complete: @escaping (_ photos: [FBPhoto], _ nextPage: String?) -> ()) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = FacebookConstants.dateFormat

        var parameters = ["fields": "name,created_time,place,link"]
        if pageCursor != nil {
            parameters.updateValue(pageCursor!, forKey: "after")
        }
        FBSDKGraphRequest(graphPath: "/\(albumId)/photos", parameters: parameters).start { (_, result, _) in
            if let parsedResult = result as? [String: Any] {
                var photos = [FBPhoto]()
                var nextPage: String?
                if let data = parsedResult["data"] as? [[String: Any]] {
                    for eachPhoto in data {
                        let id = eachPhoto["id"] as? String ?? Constants.stringBlank
                        let name = eachPhoto["name"] as? String ?? Constants.stringBlank
                        let link = eachPhoto["link"] as? String ?? Constants.stringBlank
                        let createdString = eachPhoto["created_time"] as? String ?? Constants.stringBlank
                        let created = dateFormatter.date(from: createdString)
                        var fbLocation: FBLocation?
                        if let place = eachPhoto["place"] as? [String: Any] {
                            let placeId = place["id"] as? String ?? Constants.stringBlank
                            let placeName = place["name"] as? String ?? Constants.stringBlank
                            if let location = place["location"] as? [String: Any] {
                                if let latitude = location["latitude"] as? Float, let longitude = location["longitude"] as? Float {
                                fbLocation = FBLocation(id:placeId, name: placeName, latitude: latitude, longitude: longitude)
                                }
                            }
                        }
                        let photo = FBPhoto(id: id, name: name, link: link, created: created, location: fbLocation)
                        photos.append(photo)
                    }
                }
                if let paging = parsedResult["paging"] as? [String: Any] {
                    if let cursors = paging["cursors"] as? [String: String] {
                        if let after = cursors["after"] {
                            nextPage = after
                        }
                    }
                }
                complete(photos, nextPage)
            }
        }
    }


    func getImage(imageID: String, full: Bool, complete: @escaping (_ image: UIImage) -> ()) {
        FBSDKGraphRequest(graphPath: "/\(imageID)", parameters: ["fields": "images"]).start { (_, result, _) in
            if let parsedResult = result as? [String: Any] {
                if let images = parsedResult["images"] as? [[String: Any]] {
                    var imagesArray = [[Int: String]]()
                    for eachImage in images {
                        let imageHeight = eachImage["height"] as! Int
                        let imageSource = eachImage["source"] as! String
                        imagesArray.append([imageHeight: imageSource])
                    }
                    imagesArray.sort { $0.keys.first! > $1.keys.first! }
                    let source = full ? imagesArray.first?.values.first : imagesArray.last?.values.first
                    let pictureURL = URL(string: source!)!
                    if let imageData = try? Data(contentsOf: pictureURL) {
                        let image = UIImage(data: imageData)
                        complete(image!)
                    }
                }
            }
        }
    }
}

