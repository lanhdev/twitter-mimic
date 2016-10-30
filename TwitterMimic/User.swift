//
//  User.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/25/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class User: NSObject {
  
  var name: String?
  var screen_name: String?
  var profileUrl: URL?
  var tagline: String?
  
  var dictionary: NSDictionary?
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    
    name = dictionary["name"] as? String
    screen_name = dictionary["screen_name"] as? String
    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = URL(string: profileUrlString)
    }
    tagline = dictionary["description"] as? String
  }
  
  static let userDidLogoutNotification = "UserDidLogout"
  static var _currentUser: User?
  
  class var currentUser: User? {
    get {
      // If there is no current user, check if there is any data
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: "currentUserData") as? Data
        let loginStatus = defaults.object(forKey: "loginStatus") as? Bool ?? false
        
        // If there is any data, convert it from Data type to JSON and load it to variable
        if let userData = userData {
          if loginStatus {
            let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
            _currentUser = User(dictionary: dictionary)
          }
        }
      }
      
      return _currentUser
    }
    
    set(user) {
      _currentUser = user
      
      let defaults = UserDefaults.standard
      
      // Convert user data from JSON format to Data type and store in User Defaults
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.set(data, forKey: "currentUserData")
      } else {
        defaults.set(nil, forKey: "currentUserData")
      }
      defaults.synchronize()
    }
  }
}
