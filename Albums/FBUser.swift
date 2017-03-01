//
//  FBUser.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 01/03/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    let firstName: String
    let lastName: String
    let id: String
    let picture: UIImage

    init(firstName: String, lastName: String, id: String, picture: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.picture = picture
    }

    required init?(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.picture = aDecoder.decodeObject(forKey: "picture") as! UIImage
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(picture, forKey: "picture")
    }

    func saveToFile() {
        let encodedUserData = NSKeyedArchiver.archivedData(withRootObject: self)
        let fileManager = FileManager.default
        if let userURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fbUserURL = userURL.appendingPathComponent("FBUser")
            do {
                try encodedUserData.write(to: fbUserURL)
            } catch {
                print("Couldn't write file")
            }
        }
    }

    static func deleteFile() {
        let fileManager = FileManager.default
        if let userURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fbUserURL = userURL.appendingPathComponent("FBUser")
            do {
                let _ = try fileManager.removeItem(at: fbUserURL)
            } catch {
                print("Couldn't delete file")
            }
        }
    }


    static func loadFromFile() -> User? {
        let fileManager = FileManager.default
        if let userURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fbUserURL = userURL.appendingPathComponent("FBUser")
            do {
                let encodedUserData = try Data(contentsOf: fbUserURL)
                if let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: encodedUserData) as? User {
                    return decodedUser
                }
            } catch {
                print("Couldn't read file")
            }
        }
        return nil
    }

}
