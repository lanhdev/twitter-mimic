//
//  Tweet.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/25/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var text: String?
  var name: String?
  var screen_name: String?
  var profileUrl: URL?
  var timestamp: Date?
  var id: Int = 0
  var retweetCount: Int = 0
  var favoritesCount: Int = 0
  var isRetweetedStatus: Bool?
  var isFavoritedStatus: Bool?
  
  init(dictionary: NSDictionary) {
    text = dictionary["text"] as? String
    name = dictionary.value(forKeyPath: "user.name") as? String
    screen_name = dictionary.value(forKeyPath: "user.screen_name") as? String
    let profileUrlString = dictionary.value(forKeyPath: "user.profile_image_url_https") as? String
    if let profileUrlString = profileUrlString {
      profileUrl = URL(string: profileUrlString)
    }
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
    id = (dictionary["id"] as? Int) ?? 0
    isRetweetedStatus = dictionary["retweeted"] as? Bool
    isFavoritedStatus = dictionary["favorited"] as? Bool
    
    let timestampString = dictionary["created_at"] as? String
    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString) as Date?
    }
  }
  
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    for dictionary in dictionaries {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }
    return tweets
  }
  
  func timeFormatter() -> String {
    var timeString = ""
    
    let minute = 60
    let hour = 3600
    let day = 86400
    let week = 604800

    let seconds = Date().timeIntervalSince(timestamp!)
    let durationTime = Int(seconds)
    
    if durationTime < minute {
      timeString = "\(durationTime)s"
    } else if durationTime < hour {
      timeString = "\(durationTime/minute)m"
    } else if durationTime < day {
      timeString = "\(durationTime/hour)h"
    } else if durationTime < week {
      timeString = "\(durationTime/day)d"
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yy"
      timeString = formatter.string(from: timestamp!)
    }
    
    return timeString
  }
}
