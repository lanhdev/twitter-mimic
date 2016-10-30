//
//  TweetsViewController.swift
//  TwitterMimic
//
//  Created by Macintosh on 10/27/16.
//  Copyright © 2016 Lanh Hoang. All rights reserved.
//

import UIKit
import MBProgressHUD
import ReachabilitySwift

class TweetsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]!
//  var user: User!
  
  let client = TwitterClient.sharedInstance
  let refreshControl = UIRefreshControl()
  let reachability = Reachability()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    self.refreshControl.addTarget(self, action: #selector(TweetsViewController.loadTimeline), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    loadTimeline()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(TweetsViewController.reachabilityChanged(note:)), name: ReachabilityChangedNotification, object: reachability)
    do {
      try reachability?.startNotifier()
    } catch {
      print("could not start reachability notifier")
    }
  }
  
  @IBAction func onLogoutButton(_ sender: AnyObject) {
    // Record log out status
    let defaults = UserDefaults.standard
    defaults.set(false, forKey: "loginStatus")
    print("[INFO]: loginStatus is FALSE")
    defaults.synchronize()
    
    client?.logOut()
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "detailsSegue" {
      let detailsVC = segue.destination as! TweetDetailsViewController
      let cell = sender as! UITableViewCell
      let indexPath = tableView.indexPath(for: cell)
      let tweet = self.tweets[(indexPath?.row)!]
      detailsVC.tweet = tweet
    } else if segue.identifier == "newSegue" {
      let navController = segue.destination as! UINavigationController
      let newVC = navController.topViewController as! NewTweetViewController
      newVC.user = User.currentUser
    }
  }
  
  deinit {
    reachability?.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
  }

}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func loadTimeline() {
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    client?.homeTimeline(success: { (tweets: [Tweet]) in
      self.tweets = tweets
//      for tweet in tweets {
//        print (tweet.text)
//        print ("[INFO]: \(tweet.timestamp)")
//      }
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      MBProgressHUD.hide(for: self.view, animated: true)
      }, failure: { (error: Error) in
        print("[ERROR]: \(error.localizedDescription)")
        if self.refreshControl.isRefreshing {
          self.refreshControl.endRefreshing()
          MBProgressHUD.hide(for: self.view, animated: true)
        }
    })
  }
  
  func reachabilityChanged(note: NSNotification) {
    let reachability = note.object as! Reachability
    if reachability.isReachable {
      if reachability.isReachableViaWiFi {
        print("[INFO]: Reachable via WiFi")
      } else {
        print("[INFO]: Reachable via Cellular")
      }
    } else {
      print("[ERROR]: Network not reachable")
      //      self.networkErrorView.isHidden = false
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tweets != nil {
      return tweets.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
