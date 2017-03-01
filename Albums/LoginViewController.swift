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
    private var user: User?

    private func saveProfile() {
        let firstName = FBSDKProfile.current().firstName ?? Constants.stringBlank
        let lastName = FBSDKProfile.current().lastName ?? Constants.stringBlank
        let id = FBSDKProfile.current().userID ?? Constants.stringBlank
        let picture = profilePicture.image!
        let albums = [FBAlbum]()
        let fbUser = User(firstName: firstName, lastName: lastName, id: id, picture: picture, albums: albums)
        fbUser.saveToFile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.loadFromFile()
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
                    User.deleteFile()
                }
        }
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)

        if FBSDKAccessToken.current() != nil {
            userNameLabel.text = ("\(user!.firstName) \(user!.lastName)")
            profilePicture.image = user!.picture
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if loggedIn { performSegue(withIdentifier: Constants.segueShowAlbums, sender: nil) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

