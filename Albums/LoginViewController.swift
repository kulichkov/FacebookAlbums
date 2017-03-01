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
    @IBOutlet weak var profilePicture: FBSDKProfilePictureView!
    @IBOutlet weak var continueButton: UIButton!
    var loggedIn: Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.readPermissions = Constants.loginPermissions
        if let profile = FBSDKProfile.current(),
            let firstName = profile.firstName,
            let lastName = profile.lastName {
            self.userNameLabel.text = "\(firstName) \(lastName)"
        } else {
            self.userNameLabel.text = Constants.stringUnknown
        }
        profilePicture.setNeedsImageUpdate()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange, object: nil, queue: nil) { (Notification) in
                if let profile = FBSDKProfile.current(),
                    let firstName = profile.firstName,
                    let lastName = profile.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName)"
                } else {
                    self.userNameLabel.text = Constants.stringUnknown
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
        if loggedIn { performSegue(withIdentifier: Constants.segueShowAlbums, sender: nil) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

