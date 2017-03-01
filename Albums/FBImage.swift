//
//  FBImage.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 02/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

class FBImage: NSObject, NSCoding {
    let image: UIImage!
    let thumb: UIImage!

    init(image: UIImage, thumb: UIImage) {
        self.image = image
        self.thumb = thumb
    }

    required init?(coder aDecoder: NSCoder) {
        self.image = aDecoder.decodeObject(forKey: "image") as! UIImage
        self.thumb = aDecoder.decodeObject(forKey: "thumb") as! UIImage
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(thumb, forKey: "thumb")
    }
}
