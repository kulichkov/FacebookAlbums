//
//  FBAlbum.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 01/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation

class FBAlbum: NSObject, NSCoding {
    let id: String
    let name: String
    let coverId: String
    var photos: [FBPhoto]

    init(id: String, name: String, coverId: String, photos: [FBPhoto]) {
        self.id = id
        self.name = name
        self.coverId = coverId
        self.photos = photos
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.coverId = aDecoder.decodeObject(forKey: "coverId") as! String
        self.photos = aDecoder.decodeObject(forKey: "photos") as! [FBPhoto]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coverId, forKey: "coverId")
        aCoder.encode(photos, forKey: "photos")
    }
}
