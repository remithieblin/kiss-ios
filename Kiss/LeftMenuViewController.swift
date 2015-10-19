//
//  LeftMenuViewController.swift
//  Kiss
//
//  Created by thieblin on 3/16/15.
//  Copyright (c) 2015 actimust. All rights reserved.
//



class LeftMenuViewController: UITableViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 {
            let text1 = "Hey!\n"
            let username : String = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
            let text2 = "Try this app:\niPhone:\n"
            if let iosUrl = NSURL(string: "https://itunes.apple.com/us/app/bisou/id943016663"){
                let text3 = "\n\nandroid:\n"
                if let androidUrl = NSURL(string: "https://market.android.com/details?id=com.actimust.kiss") {
                    
                    let objectsToShare = [text1, username, text2, iosUrl, text3, androidUrl]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    self.presentViewController(activityVC, animated: true, completion: nil)
                }
            }
        }
        else {
            
            func logoutConfirmed(alert: UIAlertAction!){
                
                let appDomain = NSBundle.mainBundle().bundleIdentifier!
                
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                
                
                FBSession.activeSession().closeAndClearTokenInformation()
                performSegueWithIdentifier("toLoginSegue", sender: nil)
            }
            
            var alert = UIAlertController(title: "Are you sure you want to leave?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction( title: "No!", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes..", style: UIAlertActionStyle.Default, handler: logoutConfirmed))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        return nil
    }
    

}
