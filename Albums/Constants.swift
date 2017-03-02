//
//  Constants.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 01/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation

enum FacebookConstants {
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    static let loginPermissions = ["public_profile", "email", "user_friends", "user_photos"]
}

enum Constants {
    static let stringUnknown = "Unknown"
    static let stringBlank = ""
    static let segueShowFullPhoto = "Show Full Photo"
    static let segueShowAlbums = "Show Albums"
    static let segueShowPhotos = "Show Photos"
    static let imageNoAvatar = "noavatar"
    static let imageNoPhoto = "nophoto"
    static let cellForPhotoId = "Photo Cell"
    static let cellForAlbumId = "Album Cell"
}

