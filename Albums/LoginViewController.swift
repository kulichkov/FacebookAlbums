//
//  LoginViewController.swift
//  Albums
//
//  Created by Mikhail Kulichkov on 26/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    private var loggedIn: Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        }
        return false
    }
    private var user: FBUser?

    private func saveProfile() {
        let firstName = FBSDKProfile.current().firstName ?? Constants.stringBlank
        let lastName = FBSDKProfile.current().lastName ?? Constants.stringBlank
        let id = FBSDKProfile.current().userID ?? Constants.stringBlank
        let picture = profilePicture.image!
        let albums = [FBAlbum]()
        let fbUser = FBUser(firstName: firstName, lastName: lastName, id: id, picture: picture, albums: albums)
        fbUser.saveToFile()
        user = fbUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ImagesRepo.shared
        loginButton.readPermissions = FacebookConstants.loginPermissions
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange, object: nil, queue: nil) { (Notification) in
                if let profile = FBSDKProfile.current(), let firstName = profile.firstName, let lastName = profile.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName)"
                    if let pictureData = try? Data(contentsOf: profile.imageURL(for: .square, size: CGSize(width: 100, height: 100))) {
                        self.profilePicture.image = UIImage(data: pictureData)
                    } else {
                        self.profilePicture.image = UIImage(named: Constants.imageNoAvatar)
                    }
                    self.continueButton.isHidden = false
                    self.saveProfile()
                } else {
                    self.userNameLabel.text = Constants.stringBlank
                    self.profilePicture.image = UIImage(named: Constants.imageNoAvatar)
                    self.continueButton.isHidden = true
                    FBUser.deleteFile()
                    self.user = nil
                }
        }
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)

        if FBSDKAccessToken.current() != nil {
            user = FBUser.loadFromFile()
            userNameLabel.text = ("\(user!.firstName) \(user!.lastName)")
            profilePicture.image = user!.picture
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
            profilePicture.image = UIImage(named: Constants.imageNoAvatar)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loggedIn { performSegue(withIdentifier: Constants.segueShowAlbums, sender: nil) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segueShowAlbums:
                var destination = segue.destination
                if let navController = destination as? UINavigationController {
                    destination = navController.visibleViewController!
                }
                if let AlbumsTVC = destination as? AlbumsTableViewController {
                    AlbumsTVC.user = user
                }
            default:
                break
            }
        }
    }
}

