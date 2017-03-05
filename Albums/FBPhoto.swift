//
//  FBPhoto.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 01/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation

struct FBLocation {
    let id: String
    let name: String
    let latitude: Float
    let longitude: Float
}

class FBPhoto: NSObject, NSCoding {
    let id: String
    let name: String
    let link: String
    let thumb: String
    let full: String
    let created: Date?
    let location: FBLocation?

    init(id: String, name: String, link: String, thumb: String, full:String, created: Date?, location: FBLocation?) {
        self.id = id
        self.name = name
        self.link = link
        self.thumb = thumb
        self.full = full
        self.created = created
        self.location = location
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.link = aDecoder.decodeObject(forKey: "link") as! String
        self.thumb = aDecoder.decodeObject(forKey: "thumb") as! String
        self.full = aDecoder.decodeObject(forKey: "full") as! String
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        if let locationId = aDecoder.decodeObject(forKey: "location.id") as? String, locationId != Constants.stringBlank {
            let locationName = aDecoder.decodeObject(forKey: "location.name") as! String
            let latitude = aDecoder.decodeFloat(forKey: "location.latitude")
            let longitude = aDecoder.decodeFloat(forKey: "location.longitude")
            self.location = FBLocation(id: locationId, name: locationName, latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(thumb, forKey: "thumb")
        aCoder.encode(full, forKey: "full")
        aCoder.encode(created, forKey: "created")
        aCoder.encode(location?.name, forKey: "location.name")
        aCoder.encode(location?.id, forKey: "location.id")
        if let latitude = location?.latitude {
            aCoder.encode(latitude, forKey: "location.latitude")
        } else {
            aCoder.encode(nil, forKey: "location.latitude")
        }
        if let longitude = location?.longitude {
            aCoder.encode(longitude, forKey: "location.longitude")
        } else {
            aCoder.encode(nil, forKey: "location.longitude")
        }
    }
}
