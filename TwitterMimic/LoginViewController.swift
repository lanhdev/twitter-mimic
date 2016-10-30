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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func onLogin(_ sender: UIButton) {
    TwitterClient.sharedInstance?.logIn(success: {
      print ("[INFO]: I've logged in")
      self.performSegue(withIdentifier: "loginSegue", sender: nil)
      }, failure: { (error: Error) in
      print ("[ERROR]: \(error.localizedDescription)")
    })
  }
  
  
}
