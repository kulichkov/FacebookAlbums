//
//  FacebookAPI.swift
//  SoldecTest
//
//  Created by Mikhail Kulichkov on 25/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookAPI {
    static let shared = FacebookAPI()
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = FacebookConstants.dateFormat
        return formatter
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


//    func getPhotos(albumID: String, pageCursor: String?, complete: @escaping (_ photos: [Photo], _ nextPage: String?) -> ()) {
//        let dateFormatter = DateFormatter()
//        print("::::: getPhotos called")
//        var parameters = ["fields": "name,id,picture,created_time"]
//        if pageCursor != nil {
//            parameters.updateValue(pageCursor!, forKey: "after")
//        }
//        FBSDKGraphRequest(graphPath: "/\(albumID)/photos", parameters: parameters).start { (fbConnection, result, error) in
//            print(error?.localizedDescription ?? "No errors")
//            print(fbConnection.debugDescription)
//            print("Photos was read!")
//            var photos = [Photo]()
//            var nextPage: String?
//            if let parsedResult = result as? [String: Any] {
//                if let data = parsedResult["data"] as? [[String: String]] {
//                    for eachItem in data {
//                        let photo = Photo(id: eachItem["id"], name: eachItem["name"], createdTime: dateFormatter.date(from: eachItem["created_time"] ?? ""), pictureURL: eachItem["picture"])
//                        photos.append(photo)
//                    }
//                }
//                if let paging = parsedResult["paging"] as? [String: Any] {
//                    if let cursors = paging["cursors"] as? [String: String] {
//                        if let after = cursors["after"] {
//                            nextPage = after
//                        }
//                    }
//                }
//                complete(photos, nextPage)
//                if error != nil {
//                    print(error!.localizedDescription)
//                }
//            }
//        }
//    }


//    func getPhotos(albumID: String, page: String?, complete: @escaping (_ photos: [Photo]) -> ()) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
//        print("::::: getPhotos called")
//        var parameters = ["fields": "name,id,picture,created_time"]
//        if page != nil {
//            parameters.updateValue(page!, forKey: "after")
//        }
//        FBSDKGraphRequest(graphPath: "/\(albumID)/photos", parameters: parameters).start { (fbConnection, result, error) in
//            print(error?.localizedDescription ?? "No errors")
//            print(fbConnection.debugDescription)
//            print("Photos was read!")
//            var photos = [Photo]()
//            if let parsedResult = result as? [String: Any] {
//                if let data = parsedResult["data"] as? [[String: String]] {
//                    for eachItem in data {
//                        let photo = Photo(id: eachItem["id"], name: eachItem["name"], createdTime: dateFormatter.date(from: eachItem["created_time"] ?? ""), pictureURL: eachItem["picture"])
//                        photos.append(photo)
//                    }
//                }
//                if let paging = parsedResult["paging"] as? [String: Any] {
//                    if let cursors = paging["cursors"] as? [String: String] {
//                        if let after = cursors["after"] {
//                            print(after)
//                            self.getPhotos(albumID: albumID, page: after, complete: complete)
//                        }
//                    }
//                }
//                complete(photos)
//                if error != nil {
//                    print(error!.localizedDescription)
//                }
//            }
//        }
//    }

//    func getPhotos(page: String?, handler: @escaping ([String]) -> () ) {
//        var parameters = ["fields": "name,id,picture,created_time"]
//        if page != nil {
//            parameters.updateValue(page!, forKey: "after")
//        }
//
//        FBSDKGraphRequest(graphPath: "/503085996380771/photos", parameters: parameters).start { (_, result, error) in
//
//            print(error?.localizedDescription ?? "No errors")
//            if let theResult = result as? [String: Any] {
//                if let data = theResult["data"] as? [[String: String]] {
//                    var ids = [String]()
//                    for eachItem in data {
//                        if let id = eachItem["id"] {
//                            ids.append(id)
//                        }
//                    }
//                    handler(ids)
//                }
//                if let paging = theResult["paging"] as? [String: Any] {
//                    if let cursors = paging["cursors"] as? [String: String] {
//                        if let after = cursors["after"] {
//                            self.getPhotos(page: after, handler: handler)
//                        }
//                    }
//                }
//            }
//        }
//    }


//
//    func getAlbumCoverImage(albumID: String, complete: @escaping (_ cover: UIImage) -> ()) {
//        print("::::: getCover called for id: \(albumID)")
//        FBSDKGraphRequest(graphPath: "/\(albumID)", parameters: ["fields": "cover_photo"]).start { (fbConnection, result, error) in
//            print(error?.localizedDescription ?? "No errors")
//            if result != nil {
//                if JSONSerialization.isValidJSONObject(result!) {
//                    print("Cover was read!")
//                    if let parsedResult = result as? [String: Any] {
//                        if let coverPhoto = parsedResult["cover_photo"] as? [String: String] {
//                            if let id = coverPhoto["id"] {
//                                self.getSmallImage(imageID: id) { image in
//                                    complete(image)
//                                }
//                            }
//                        }
//                        if let paging = parsedResult["paging"] as? [String: String] {
//                            print(paging)
//                        }
//                    }
//                }
//                if error != nil {
//                    print(error!.localizedDescription)
//                }
//            }
//        }
//    }
//

    func getImage(imageID: String, height: Int, complete: @escaping (_ image: UIImage) -> ()) {
        FBSDKGraphRequest(graphPath: "/\(imageID)", parameters: ["fields": "images"]).start { (_, result, _) in
            if let parsedResult = result as? [String: Any] {
                if let images = parsedResult["images"] as? [[String: Any]] {
                    for eachImage in images {
                        if let imageHeight = eachImage["height"] as? Int {
                            if imageHeight < height {
                                if let imageURL = eachImage["source"] as? String {
                                    let pictureURL = URL(string: imageURL)!
                                    let urlSession = URLSession(configuration: .default)
                                    urlSession.dataTask(with: pictureURL, completionHandler: { (imageData, _, _) in
                                        if imageData != nil {
                                            let image = UIImage(data: imageData!)
                                            DispatchQueue.main.sync {
                                                complete(image!)
                                            }
                                        }
                                    }).resume()

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

