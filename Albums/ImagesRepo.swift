//
//  ImagesRepo.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 02/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

class ImagesRepo: NSObject, NSCoding {
    static let shared: ImagesRepo = {
        if let singleton = loadFromFile() {
            return singleton
        }
        return ImagesRepo(images: [String: UIImage](), thumbs: [String: UIImage]())
    }()

    private var images: [String: UIImage]
    private var thumbs: [String: UIImage]

    func image(id: String) -> UIImage? {
        if let image = images[id] {
            return image
        }
        return nil
    }

    func thumb(id: String) -> UIImage? {
        if let thumb = thumbs[id] {
            return thumb
        }
        return nil
    }

    func updateImage(image: UIImage, id: String) {
        images.updateValue(image, forKey: id)
    }

    func updateThumb(image: UIImage, id: String) {
        thumbs.updateValue(image, forKey: id)
    }

    init(images: [String: UIImage], thumbs: [String: UIImage]) {
        self.images = images
        self.thumbs = thumbs
    }

    required init?(coder aDecoder: NSCoder) {
        self.images = aDecoder.decodeObject(forKey: "images") as! [String: UIImage]
        self.thumbs = aDecoder.decodeObject(forKey: "thumbs") as! [String: UIImage]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
        aCoder.encode(thumbs, forKey: "thumbs")
    }

    func saveToFile() {
        let encodedImagesRepoData = NSKeyedArchiver.archivedData(withRootObject: self)
        let fileManager = FileManager.default
        if let imagesRepoURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fbImagesRepoURL = imagesRepoURL.appendingPathComponent("ImagesRepo")
            do {
                try encodedImagesRepoData.write(to: fbImagesRepoURL)
            } catch {
                print("Couldn't write ImagesRepo file")
            }
        }
    }

    static func loadFromFile() -> ImagesRepo? {
        let fileManager = FileManager.default
        if let imagesRepoURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fbImagesRepoURL = imagesRepoURL.appendingPathComponent("ImagesRepo")
            do {
                let encodedImagesRepoData = try Data(contentsOf: fbImagesRepoURL)
                if let decodedImagesRepo = NSKeyedUnarchiver.unarchiveObject(with: encodedImagesRepoData) as? ImagesRepo {
                    return decodedImagesRepo
                }
            } catch {
                print("Couldn't read ImagesRepo file")
            }
        }
        return nil
    }

}
