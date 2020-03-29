//
//  LoginViewController.swift
//  TwitterSignInExample
//
//  Created by John Codeos on 3/8/20.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import SafariServices
import Swifter
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var twitterLoginBtn: UIButton!
    
    
    
    var twitterId = ""
    var twitterHandle = ""
    var twitterName = ""
    var twitterEmail = ""
    var twitterProfilePicURL = ""
    var twitterAccessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.twitterLoginBtn.layer.cornerRadius = 10.0
        
        self.isLoggedIn { loggedin in
            if loggedin {
                // Show the ViewController with the logged in user
                print("Logged In?: YES")
            } else {
                // Show the Home ViewController
                print("Logged In?: NO")
            }
        }
    }
    
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    
    @IBAction func twitterLoginBtnAction(_ sender: UIButton) {
        self.swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
        self.swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
            self.accToken = accessToken
            self.getUserProfile()
        }, failure: { _ in
            print("ERROR: Trying to authorize")
        })
    }
    
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            // Twitter Id
            if let twitterId = json["id_str"].string {
                print("Twitter Id: \(twitterId)")
                self.twitterId = twitterId
            } else {
                self.twitterId = "Not exists"
            }

            // Twitter Handle
            if let twitterHandle = json["screen_name"].string {
                print("Twitter Handle: \(twitterHandle)")
                self.twitterHandle = twitterHandle
            } else {
                self.twitterHandle = "Not exists"
            }

            // Twitter Name
            if let twitterName = json["name"].string {
                print("Twitter Name: \(twitterName)")
                self.twitterName = twitterName
            } else {
                self.twitterName = "Not exists"
            }

            // Twitter Email
            if let twitterEmail = json["email"].string {
                print("Twitter Email: \(twitterEmail)")
                self.twitterEmail = twitterEmail
            } else {
                self.twitterEmail = "Not exists"
            }

            // Twitter Profile Pic URL
            if let twitterProfilePic = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) {
                print("Twitter Profile URL: \(twitterProfilePic)")
                self.twitterProfilePicURL = twitterProfilePic
            } else {
                self.twitterProfilePicURL = "Not exists"
            }
            print("Twitter Access Token: \(self.accToken?.key ?? "Not exists")")
            self.twitterAccessToken = self.accToken?.key ?? "Not exists"

            // Save the Access Token (accToken.key) and Access Token Secret (accToken.secret) using UserDefaults
            // This will allow us to check user's logging state every time they open the app after cold start.
            let userDefaults = UserDefaults.standard
            userDefaults.set(self.accToken?.key, forKey: "oauth_token")
            userDefaults.set(self.accToken?.secret, forKey: "oauth_token_secret")

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "detailseg", sender: self)
            }
        }) { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func isLoggedIn(completion: @escaping (Bool) -> ()) {
        let userDefaults = UserDefaults.standard
        let accessToken = userDefaults.string(forKey: "oauth_token") ?? ""
        let accessTokenSecret = userDefaults.string(forKey: "oauth_token_secret") ?? ""
        
        let swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY, oauthToken: accessToken, oauthTokenSecret: accessTokenSecret)
        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { _ in
            // Verify Succeed - Access Token is valid
            completion(true)
        }) { _ in
            // Verify Failed - Access Token has expired
            completion(false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailseg" {
            let DestView = segue.destination as! DetailsViewController
            DestView.twitterId = self.twitterId
            DestView.twitterHandle = self.twitterHandle
            DestView.twitterName = self.twitterName
            DestView.twitterEmail = self.twitterEmail
            DestView.twitterProfilePicURL = self.twitterProfilePicURL
            DestView.twitterAccessToken = self.twitterAccessToken
        }
    }
}

// Show the Authorization screen inside the app instead of opening Safari
extension LoginViewController: SFSafariViewControllerDelegate {}
