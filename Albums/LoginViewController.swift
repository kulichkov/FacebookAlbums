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
        loginButton.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
        if let profile = FBSDKProfile.current(),
            let firstName = profile.firstName,
            let lastName = profile.lastName {
            self.userNameLabel.text = "\(firstName) \(lastName)"
        } else {
            self.userNameLabel.text = "Unknown"
        }

        profilePicture.setNeedsImageUpdate()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.FBSDKProfileDidChange, object: nil, queue: nil) { (Notification) in
                if let profile = FBSDKProfile.current(),
                    let firstName = profile.firstName,
                    let lastName = profile.lastName {
                    self.userNameLabel.text = "\(firstName) \(lastName)"
                } else {
                    self.userNameLabel.text = "Unknown"
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
        if loggedIn { performSegue(withIdentifier: "Show MainVC", sender: nil) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show MainVC":
                if let destination = segue.destination as? AlbumsViewController {

                }
            default:
                break
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/

//    func loginButton(_ loginButton: FBSDKLoginButton!,
//                     didCompleteWith result: FBSDKLoginManagerLoginResult!,
//                     error: Error!) {
//        if let result = result {
//            print("Logged in")
//            // Notify our web API that this user has logged in with Facebook
//        }
//    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logging out")
    }
}

