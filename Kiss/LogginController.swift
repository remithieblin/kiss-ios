//
//  LogginController.swift
//  Kiss
//
//  Created by thieblin on 11/8/14.
//  Copyright (c) 2014 actimust. All rights reserved.
//

import UIKit
import Parse

class LogginController: UIViewController {
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    @IBOutlet var imageView : UIImageView!
    
    var signingIn = false
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userNameTextField.becomeFirstResponder()
        
        if(signingIn){
            self.title = "Login"
        }else{
            self.title = "Sign up"
        }
        
//        self.fbLoginView.delegate = self
//        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
//        self.imageView.layer.cornerRadius = 25

        
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Name: \(user.name)")
        println("user.username: \(user.username)")
        
        FBRequestConnection.startForMeWithCompletionHandler { (connection, user, error) -> Void in
            println(user)
            var id: String = user.objectForKey("id") as String
            let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                
                println("Got the image")
                // Display the image
                let image = UIImage(data: data)
                        self.imageView.layer.cornerRadius = 25
                self.imageView.clipsToBounds = true
                self.imageView.image = image
                
            }
            
            
            var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
            friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                var resultdict = result as NSDictionary
                println("Result Dict: \(resultdict)")
                var data : NSArray = resultdict.objectForKey("data") as NSArray
                
                for i in 0..<data.count {
                    let valueDict : NSDictionary = data[i] as NSDictionary
                    let id = valueDict.objectForKey("id") as String
                    println("the id value is \(id)")
                }
                
                var friends = resultdict.objectForKey("data") as NSArray
                println("Found \(friends.count) friends")
            }
            
        }
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    @IBAction func doneLoggin(sender: AnyObject) {
        
        doneButton.enabled = false
        
        if(signingIn){
            PFUser.logInWithUsernameInBackground (userNameTextField.text, password: passwordTextField.text, block: signInCallBack)
            
        }else{
            var user = PFUser()
            user.username = userNameTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackgroundWithBlock(signUpCallBack)
        }
    }
    
    func signInCallBack(user: PFUser!, error: NSError!){
        if error == nil {
            registerParseInstallation(userNameTextField.text)
            let friendsList: String? = user["friendsList"] as String?

            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
            NSUserDefaults.standardUserDefaults().setObject(userNameTextField.text, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(friendsList, forKey: "friendsKey")
            
            performSegueWithIdentifier("loggedinToListSegue", sender: self)
        }
        else {
            doneButton.enabled = true
            let errorString = error.userInfo!["error"] as NSString
            var alert = UIAlertController(title: "Hmm, something went wrong:" , message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction( title: "Back", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func signUpCallBack(succeeded: Bool!, error: NSError!){
        if error == nil {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggedIn")
            NSUserDefaults.standardUserDefaults().setObject(userNameTextField.text, forKey: "username")
            registerParseInstallation(userNameTextField.text)
            performSegueWithIdentifier("loggedinToListSegue", sender: self)
            
        } else {
            let errorString = error.userInfo!["error"] as NSString
            var alert = UIAlertController(title: "Hmm, something went wrong:" , message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction( title: "Back", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func registerParseInstallation(username: String){
        var installation: PFInstallation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation["userId"] = username
        installation.saveEventually()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
