//
//  NewTweetViewController.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/30/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var characterCountLabel: UILabel!
  @IBOutlet weak var tweetTextField: UITextView!

  var user: User!
  
  let client = TwitterClient.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if user.profileUrl != nil {
      avatarImage.setImageWith(user.profileUrl!)
    }
    usernameLabel.text = user.name
    screennameLabel.text = "@" + user.screen_name!
    tweetTextField.becomeFirstResponder()
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func composeButton(_ sender: UIBarButtonItem) {
      client?.newTweet(status: tweetTextField.text!, success: { (dictionary: NSDictionary) in
        print("[INFO]: Hear me tweet")
        }, failure: { (error: Error) in
          print("[ERROR]:\(error.localizedDescription)")
      })
      dismiss(animated: true, completion: nil)
  }
}
