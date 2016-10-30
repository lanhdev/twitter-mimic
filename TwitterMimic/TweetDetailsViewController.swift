//
//  TweetDetailsViewController.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/29/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var favoriteButtonView: UIButton!
  @IBOutlet weak var retweetButtonView: UIButton!
  
  var tweet: Tweet!
  var isFavorited: Bool?
  var isRetweeted: Bool?
  
  let client = TwitterClient.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    updateTweetInfo()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTweetInfo()
  }
  
  @IBAction func favoriteButton(_ sender: UIButton) {
    if isFavorited! {
      client?.unlikeTweet(id: tweet.id, success: { (response: Any) in
        print("[INFO]: Favorite is gone")
        self.tweet = Tweet(dictionary: response as! NSDictionary)
        self.updateTweetInfo()
        }, failure: { (error: Error) in
          print("[ERROR]:\(error.localizedDescription)")
      })
    } else {
      client?.likeTweet(id: tweet.id, success: { (response: Any) in
        print("[INFO]: Favorite is all around")
        self.tweet = Tweet(dictionary: response as! NSDictionary)
        self.updateTweetInfo()
        }, failure: { (error: Error) in
          print("[ERROR]:\(error.localizedDescription)")
      })
    }
  }
  
  @IBAction func retweetButton(_ sender: UIButton) {
    if isRetweeted! {
      client?.unreTweet(id: tweet.id, success: { (response: Any) in
        print("[INFO]: Retweet is gone")
        self.tweet = Tweet(dictionary: response as! NSDictionary)
        self.updateTweetInfo()
        }, failure: { (error: Error) in
          print("[ERROR]:\(error.localizedDescription)")
      })
    } else {
      client?.reTweet(id: tweet.id, success: { (response: Any) in
        print("[INFO]: Retweet is all around")
        self.tweet = Tweet(dictionary: response as! NSDictionary)
        self.updateTweetInfo()
        }, failure: { (error: Error) in
          print("[ERROR]:\(error.localizedDescription)")
      })
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navController = segue.destination as! UINavigationController
    let replyVC = navController.topViewController as! ReplyViewController
    replyVC.tweet = tweet
  }
  
  func updateTweetInfo() {
    if tweet.profileUrl != nil {
      avatarImage.setImageWith(tweet.profileUrl!)
    }
    usernameLabel.text = tweet.name
    screennameLabel.text = "@" + tweet.screen_name!
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm, dd MMM yy"
    timestampLabel.text = formatter.string(from: tweet.timestamp!)
    
    tweetLabel.text = tweet.text
    retweetCountLabel.text = String(format: "%d", tweet.retweetCount)
    favoriteCountLabel.text = String(format: "%d", tweet.favoritesCount)
    
    isFavorited = tweet.isFavoritedStatus
    isRetweeted = tweet.isRetweetedStatus
    
    if isFavorited! {
      favoriteButtonView.setBackgroundImage(UIImage(named: "heart_on"), for: UIControlState.normal)
    } else {
      favoriteButtonView.setBackgroundImage(UIImage(named: "heart_off"), for: UIControlState.normal)
    }
    
    if isRetweeted! {
      retweetButtonView.setBackgroundImage(UIImage(named: "retweet_on"), for: UIControlState.normal)
    } else {
      retweetButtonView.setBackgroundImage(UIImage(named: "retweet_off"), for: UIControlState.normal)
    }
  }
}
