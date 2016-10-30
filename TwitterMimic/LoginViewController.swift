//
//  LoginViewController.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/25/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
  
  let baseURL = "https://api.twitter.com/"
  let consumerKey = "A1jilLpgMrDjtz7HpV2779ZqT"
  let consumerSecret = "pKbRlP81APf6OkLVRK485ClzDzSKY1X7eB56HNJOPpEBo6Y6Kh"
  
  let callbackURL = "twittermimic://auth"
  
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    loadTheme()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    self.loginButton.setBackgroundImage(UIImage(named: "money.png"), for: UIControlState.normal)
    self.loginButton.alpha = 0.0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIButton.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
      self.loginButton.alpha = 1.0
    }) { (true) in
      print ("Completed")
    }
  }
  
  func loadTheme() {
    UIApplication.shared.statusBarStyle = .lightContent
    navigationController?.navigationBar.barTintColor = Style.barColor
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Style.foregroundColor]
    navigationController?.navigationBar.tintColor = Style.foregroundColor // Set text color for back button
  }
  
  @IBAction func onLogin(_ sender: UIButton) {
    TwitterClient.sharedInstance?.logIn(success: {
      print ("[INFO]: I've logged in")
      self.performSegue(withIdentifier: "loginSegue", sender: nil)
      }, failure: { (error: Error) in
      print ("[ERROR]: \(error.localizedDescription)")
    })
  }
  
  
}
