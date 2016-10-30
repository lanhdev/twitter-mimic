//
//  TweetCell.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/29/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      if tweet.profileUrl != nil {
        avatarImage.setImageWith(tweet.profileUrl!)
      }
      usernameLabel.text = tweet.name
      screennameLabel.text = "@" + tweet.screen_name!
      timestampLabel.text = tweet.timeFormatter()
      tweetLabel.text = tweet.text
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
