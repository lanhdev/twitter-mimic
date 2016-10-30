//
//  ReplyViewController.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/31/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var characterCountLabel: UILabel!
  @IBOutlet weak var tweetTextField: UITextView!
  
  var tweet: Tweet!
  
  let client = TwitterClient.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if tweet.profileUrl != nil {
      avatarImage.setImageWith(tweet.profileUrl!)
    }
    usernameLabel.text = tweet.name
    screennameLabel.text = "@" + tweet.screen_name!
    tweetTextField.becomeFirstResponder()
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func composeButton(_ sender: UIBarButtonItem) {
    let status = "@" + tweet.screen_name! + " " + tweetTextField.text
    client?.replyTweet(status: status, inReplyToStatusId: tweet.id, success: { (dictionary: NSDictionary) in
      print("[INFO]: Hear me reply")
    }, failure: { (error: Error) in
      print("[ERROR]:\(error.localizedDescription)")
    })
    dismiss(animated: true, completion: nil)
  }
}
