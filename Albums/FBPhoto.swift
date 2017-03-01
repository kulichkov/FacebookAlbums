//
//  FBPhoto.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 01/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation

struct FBLocation {
    let latitude: Double
    let longitude: Double
}

class FBPhoto: NSObject, NSCoding {
    let id: String
    let name: String
    let created: Date
    let location: FBLocation?

    init(id: String, name: String, created: Date, location: FBLocation) {
        self.id = id
        self.name = name
        self.created = created
        self.location = location
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.created = aDecoder.decodeObject(forKey: "created") as! Date
        let latitude = aDecoder.decodeDouble(forKey: "location.latitude")
        let longitude = aDecoder.decodeDouble(forKey: "location.longitude")
        self.location = FBLocation(latitude: latitude, longitude: longitude)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(created, forKey: "created")
        aCoder.encode(location?.latitude, forKey: "location.latitude")
        aCoder.encode(location?.longitude, forKey: "location.longitude")
    }
}
