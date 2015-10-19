//
//  AddFriendViewController.swift
//  Kiss
//
//  Created by thieblin on 10/29/14.
//  Copyright (c) 2014 actimust. All rights reserved.
//

import UIKit
import Parse

class AddFriendViewController: UIViewController {


    @IBOutlet weak var friendNameTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendNameTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        println("check")
        println(identifier)
        
        var query = PFUser.query()
        query.whereKey("username", equalTo:friendNameTextField.text)
        
        let error: NSErrorPointer = nil
        let count = query.countObjects(error)
        
        if error == nil {
            println("count: \(count) ")
            
            if count > 0 { return true }
                
            else {
                var alert = UIAlertController(title: "No user with name " + self.friendNameTextField.text
                    + " exists. Please invite him!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction( title: "Not now", style: UIAlertActionStyle.Default, handler: nil))
                
                alert.addAction(UIAlertAction(title: "invite", style: UIAlertActionStyle.Default, handler: { alert in
                    
                    let text1 = "Hey! Add me: "
                    let username : String = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
                    let text2 = ", on the kiss app:\nios:"
                    if let iosUrl = NSURL(string: "https://itunes.apple.com/us/app/bisou/id943016663"){
                        let text3 = "\n\nandroid:\n"
                        if let androidUrl = NSURL(string: "https://market.android.com/details?id=com.actimust.kiss") {
                            
                            let objectsToShare = [text1, username, text2, iosUrl, text3, androidUrl]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            
                            self.presentViewController(activityVC, animated: true, completion: nil)}}
                    
                }))

                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        return false
        
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {

        
    }
 
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func shareClicked(sender: AnyObject) {
        
        let text1 = "Hey! Add me: "
        let username : String = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        let text2 = ", on the kiss app:\nios:"
        if let iosUrl = NSURL(string: "https://itunes.apple.com/us/app/bisou/id943016663"){
            let text3 = "\n\nandroid:\n"
            if let androidUrl = NSURL(string: "https://market.android.com/details?id=com.actimust.kiss") {
                
                let objectsToShare = [text1, username, text2, iosUrl, text3, androidUrl]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)}}
        
    }
    
    
}
