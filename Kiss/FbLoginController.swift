//
//  FbLoginController.swift
//  Kiss
//
//  Created by thieblin on 3/2/15.
//  Copyright (c) 2015 actimust. All rights reserved.
//

import UIKit
import Parse

class FbLoginController: UIViewController , FBLoginViewDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        
        let lastFetch = NSUserDefaults.standardUserDefaults().doubleForKey("lastFetch")
        let date = NSDate().timeIntervalSince1970

        // bug facebook sdk: this callback is called twice in a row
        if  lastFetch.distanceTo(date) > 2 {
        
            NSUserDefaults.standardUserDefaults().setDouble(date, forKey: "lastFetch")

            let id: String = user.objectForKey("id") as String
            FBRequestConnection.startForMeWithCompletionHandler { (connection, user, error) -> Void in
                let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
                let urlRequest = NSURLRequest(URL: url!)
                
            }

            var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
            friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                
                if error == nil {
                    var resultdict = result as NSDictionary
                    var data : NSArray = resultdict.objectForKey("data") as NSArray
                    
                    var friends: [AnyObject] = []
                    
                    //TODO remove user:
                    
                    let user = ["fname":user.first_name,"id": id, "lastSend":0, "countOut":0]
                    friends.append(user)
//                    friends.append(user)
                    
                    
                    for i in 0..<data.count {
                        let valueDict : NSDictionary = data[i] as NSDictionary
                        let id = valueDict.objectForKey("id") as String
                        let fname = valueDict.objectForKey("first_name") as String
                        
                        let friend = ["fname":fname,"id": id, "lastSend":0, "countOut":0]
                        friends.append(friend)
                    }
                    let friendsJson: AnyObject = JSON(friends).rawValue
                    NSUserDefaults.standardUserDefaults().setObject(friendsJson, forKey: "friendsKey")
                }
            }
            registerParseInstallation(id)
            NSUserDefaults.standardUserDefaults().setObject(user.first_name, forKey: "username")
            self.performSegueWithIdentifier("fbLoggedIn", sender: self)
        }
    }
    
    func registerParseInstallation(fbId: String){
        var installation: PFInstallation = PFInstallation.currentInstallation()
        installation["fid"] = fbId
        installation.saveEventually({ (result, error) -> Void in
        })
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
//        println("Error: \(handleError.localizedDescription)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
