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
    var loggedIn: Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        }
        return false
    }

    private func saveProfile() {
        let firstName = FBSDKProfile.current().firstName ?? Constants.stringBlank
        let lastName = FBSDKProfile.current().lastName ?? Constants.stringBlank
        let id = FBSDKProfile.current().userID ?? Constants.stringBlank
        var picture: UIImage!
        if let pictureData = try? Data(contentsOf: FBSDKProfile.current().imageURL(for: .square, size: CGSize(width: 100, height: 100))) {
            picture = UIImage(data: pictureData)
        } else {
            picture = UIImage(named: Constants.imageNoAvatar)
        }
        let fbUser = User(firstName: firstName, secondName: lastName, id: id, picture: picture)
        fbUser.saveToFile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.loadFromFile() {
            
        }
        loginButton.readPermissions = Constants.loginPermissions
        if let profile = FBSDKProfile.current(),
            let firstName = profile.firstName,
            let lastName = profile.lastName {
            self.userNameLabel.text = "\(firstName) \(lastName)"
            if let pictureData = try? Data(contentsOf: profile.imageURL(for: .square, size: CGSize(width: 100, height: 100))) {
                profilePicture.image = UIImage(data: pictureData)
            }
        } else {

            self.userNameLabel.text = Constants.stringBlank
            profilePicture.image = UIImage(named: Constants.imageNoAvatar)
        }

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange, object: nil, queue: nil) { (Notification) in
                if let profile = FBSDKProfile.current(),
                    let firstName = profile.firstName,
                    let lastName = profile.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName)"
                    
                } else {
                    self.userNameLabel.text = Constants.stringBlank
                }
                if FBSDKAccessToken.current() != nil {
                    self.continueButton.isHidden = false
                } else {
                    self.continueButton.isHidden = true
                }
        }
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        if FBSDKAccessToken.current() != nil {
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

