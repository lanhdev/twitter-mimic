//
//  TwitterClient.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/26/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let consumerKey = "00zJFYMDOg9pxu0555ZzTPFNc"
let consumerSecret = "ogC8m5ax5lLjetPqHg0RJZEbgWBzyhnWm9B9x7rO9AWBiSs64e"
let baseUrl = "https://api.twitter.com/"
let callbackUrl = "twittermimic://auth"

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: URL(string: baseUrl), consumerKey: consumerKey, consumerSecret: consumerSecret)
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func logIn(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    deauthorize()
    fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: callbackUrl), scope: nil, success: { (response: BDBOAuth1Credential?) in
      print ("I get the request token \(response?.token)")

      if let response = response {
        let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
        UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
        
        // Record log in status
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "loginStatus")
        print("[INFO]: loginStatus is TRUE")
        defaults.synchronize()
        
      } else {
        print ("response is nil")
      }
      
      }, failure: { (error: Error?) in
        print ("\(error?.localizedDescription)")
        self.loginFailure!(error!)
    })
  }
  
  func logOut() {
    User.currentUser = nil
    deauthorize()
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    print (requestToken)
    
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (response: BDBOAuth1Credential?) in
      
      self.currentAccount(success: { (user: User) in
        User.currentUser = user
        self.loginSuccess!()
      }, failure: { (error: Error) in
        self.loginFailure!(error)
      })
      
    }, failure: { (error: Error?) in
        print ("\(error?.localizedDescription)")
        self.loginFailure!(error!)
    })
  }
  
  func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      success(tweets)
      
      }, failure: { (task: URLSessionDataTask?, error: Error) in
       failure(error)
    })
  }
  
  func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      // get user
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)
      
      success(user)
      }, failure: { (task: URLSessionDataTask?, error: Error) in
        failure(error)
        print ("\(error.localizedDescription)")
    })
  }
  
  func newTweet(status: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["status"] = status
    
    post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
      success(dictionary)
      print("[INFO]: Prepare yourself, new tweet is coming")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  func replyTweet(status: String, inReplyToStatusId: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["status"] = status
    parameters["in_reply_to_status_id"] = inReplyToStatusId
    
    post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
//      let tweet = Tweet(dictionary: dictionary)
      success(dictionary)
      print("[INFO]: Prepare yourself, reply is coming")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  func likeTweet(id: Int, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["id"] = id
    
    post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
      success(dictionary)
      print("[INFO]: May the favorite be with you")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  func unlikeTweet(id: Int, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["id"] = id
    
    post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
      success(dictionary)
      print("[INFO]: No favorite, no love")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  func reTweet(id: Int, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["id"] = id
    
    post("1.1/statuses/retweet/\(id).json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
      success(dictionary)
      print("[INFO]: Retweet came in like a wrecking ball")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  func unreTweet(id: Int, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
    var parameters = Dictionary<String, Any>()
    parameters["id"] = id
    
    post("1.1/statuses/unretweet/\(id).json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      let dictionary = response as! NSDictionary
      success(dictionary)
      print("[INFO]: No more retweet")
    }) { (task: URLSessionDataTask?, error: Error) in
      failure(error)
      print("[ERROR]:\(error.localizedDescription)")
    }
  }
  
  
}
