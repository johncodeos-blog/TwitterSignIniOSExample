//
//  DetailsViewController.swift
//  TwitterSignInExample
//
//  Created by John Codeos on 3/8/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet var twitterIdLabel: UILabel!
    @IBOutlet var twitterHandleLabel: UILabel!
    @IBOutlet var twitterNameLabel: UILabel!
    @IBOutlet var twitterEmailLabel: UILabel!
    @IBOutlet var twitterProfilePicUrlLabel: UILabel!
    @IBOutlet var twitterAccessTokenLabel: UILabel!

    var twitterId = ""
    var twitterHandle = ""
    var twitterName = ""
    var twitterEmail = ""
    var twitterProfilePicURL = ""
    var twitterAccessToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        twitterIdLabel.text = twitterId
        twitterHandleLabel.text = twitterHandle
        twitterNameLabel.text = twitterName
        twitterEmailLabel.text = twitterEmail
        twitterProfilePicUrlLabel.text = twitterProfilePicURL
        twitterAccessTokenLabel.text = "HIDDEN"
    }
}
