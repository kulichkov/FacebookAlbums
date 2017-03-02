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
    let latitude: Double
    let longitude: Double
}

class FBPhoto: NSObject, NSCoding {
    let id: String
    let name: String
    let created: Date?
    let location: FBLocation?

    init(id: String, name: String, created: Date?, location: FBLocation?) {
        self.id = id
        self.name = name
        self.created = created
        self.location = location
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        let locationId = aDecoder.decodeObject(forKey: "location.id") as! String
        if locationId != Constants.stringBlank {
            let locationName = aDecoder.decodeObject(forKey: "location.name") as! String
            let latitude = aDecoder.decodeDouble(forKey: "location.latitude")
            let longitude = aDecoder.decodeDouble(forKey: "location.longitude")
            self.location = FBLocation(id: locationId, name: locationName, latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(created, forKey: "created")
        aCoder.encode(location?.name, forKey: "location.name")
        aCoder.encode(location?.id, forKey: "location.id")
        aCoder.encode(location?.latitude, forKey: "location.latitude")
        aCoder.encode(location?.longitude, forKey: "location.longitude")
    }
}
