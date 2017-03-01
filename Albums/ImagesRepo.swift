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
        return ImagesRepo(images: [String : FBImage]())
    }()

    private var images: [String: FBImage]

    func image(id: String) -> UIImage? {
        if let image = images[id]?.image {
            return image
        }
        return nil
    }

    func thumb(id: String) -> UIImage? {
        if let thumb = images[id]?.thumb {
            return thumb
        }
        return nil
    }

    func updateImageAndThumb(image: UIImage, thumb: UIImage, id: String) {
        let fbImage = FBImage(image: image, thumb: thumb)
        images.updateValue(fbImage, forKey: id)
    }

    init(images: [String: FBImage]) {
        self.images = images
    }

    required init?(coder aDecoder: NSCoder) {
        self.images = aDecoder.decodeObject(forKey: "images") as! [String: FBImage]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
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
