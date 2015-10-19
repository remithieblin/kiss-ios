//
//  FriendsListTableViewController.swift
//  Kiss
//
//  Created by thieblin on 10/30/14.
//  Copyright (c) 2014 actimust. All rights reserved.
//

import UIKit
import Swift
import Parse

class ListTableViewController: UITableViewController {

    @IBOutlet var longPressGestureManager: UILongPressGestureRecognizer!

    var friends: [Friend] = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loggedIn : Bool = NSUserDefaults.standardUserDefaults().boolForKey("loggedIn")
        
        
        if let friendsRaw: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("friendsKey"){
            let friendsJson = JSON(friendsRaw)
            setFriends(friendsJson)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationReceived:", name: "notificationObserver", object: nil)
    
    }
    
    func setFriends(friendsJson: JSON){
        let array = friendsJson.arrayValue
        for json in array {
            let friend = Friend(name:json["fname"].string! , id:json["id"].string!, lastSend:json["lastSend"].int!, countOut:json["countOut"].int!)
            friends.append(friend)
        }
    }
    
    func orderFriends(){
        friends = Friend.orderByCount(friends)
    }
    
    dynamic func notificationReceived(notification: NSNotification){
        
        let friendToAddFromNotif = NSUserDefaults.standardUserDefaults().stringForKey("friendFromNotif")
        if friendToAddFromNotif != nil {
        
            var alert = UIAlertController(title: friendToAddFromNotif! + " sent you a kiss!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { alert in
                
                let cells = self.tableView.visibleCells()
                for cell in cells {
                    if let customCell = cell as? CustomCell {
                        if customCell.name == friendToAddFromNotif {
                            self.animateCell(cell as? UITableViewCell)
                            break
                        }
                    }
                }
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            

        }
    }
    
    func animateCell(cell: UITableViewCell?){
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromTop
        
        UIView.animateWithDuration(1.0, animations: {
            
            }, completion: { finished in
                
                UIView.transitionWithView(cell! , duration: 1.0, options: transitionOptions,
                    animations: {

                    },
                    completion: { finished in

                })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        let source: AddFriendViewController = segue.sourceViewController as AddFriendViewController
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : CustomCell = tableView.dequeueReusableCellWithIdentifier("customCell") as CustomCell
        
        let friend: Friend = friends[indexPath.row]
        cell.setCell(friend)
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "onLongPress:"))
        

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let row: CustomCell = tableView.cellForRowAtIndexPath(indexPath) as CustomCell

        if Utils.isConnectedToNetwork(){
            pushNotification(self.friends[indexPath.row].id)
            
            let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
            var kissView = row.kissImage
            
            kissView.hidden = false
            
            UIView.animateWithDuration(1.0, animations: {
                
                }, completion: { finished in
                    
                    UIView.transitionWithView(row, duration: 1.0, options: transitionOptions, animations: {
                        //                        kissView.alpha = 0.0
                        },
                        completion: { finished in
                            kissView.hidden = true
                            self.friends[indexPath.row].countOut++
                            self.orderFriends()
                            tableView.reloadData()
                    })
            })
        }
        else{
            println("No connection")
            var alert = UIAlertController(title: "No connection :(", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        return nil
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            friends.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func pushNotification(fid: String){
        var url : String = "https://api.parse.com/1/push"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "POST"
        
        var userId: NSMutableDictionary = NSMutableDictionary()
        userId.setValue(fid, forKey: "fid")
        
        let username : String = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var data: NSMutableDictionary = NSMutableDictionary()
        data.setValue(username, forKey: "alert")
        data.setValue("Increment", forKey: "badge")
        
        
        var root: NSMutableDictionary = NSMutableDictionary()
        root.setValue(userId, forKey: "where")
        root.setValue(data, forKey: "data")
        
        let body = NSJSONSerialization.dataWithJSONObject(root, options: nil, error: nil)
        
        request.HTTPBody = body
        
        request.setValue("IhQUzYBXBEBhdAoMGQJ5xJnNHkjxLtxeUc8UBJML", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("o0KzNqhHhzR1YVKn8x3SxnTDJs47X9EMoecqoXhF", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
        })
    }
    
    
    @IBAction func onLongPress(gesture: UIGestureRecognizer) {
        
//        if gesture.state == UIGestureRecognizerState.Began{
//            let username = (gesture.view as CustomCell).name
//            let id = (gesture.view as CustomCell).id
//            
//            var alert = UIAlertController(title: "Delete " + username + "?" , message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let cancelClosure = {(alert: UIAlertAction!) in println("cancel")}
//
//            func removeFriend(alert: UIAlertAction!){
//                
//                var index = 0
//                for i in 0...friends.count-1 {
//                    if friends[i].id == id {
//                        index = i
//                        break
//                    }
//                }
//                friends.removeAtIndex(index)
//                self.tableView.reloadData()
//            }
//            
//            alert.addAction(UIAlertAction( title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelClosure))
//            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: removeFriend))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    func saveFriendsListToParseUser(friendsList: [AnyObject]){
        let listAsString = ",".join(friendsList as [String])
        var user = PFUser.currentUser()
        user["friendsList"] = listAsString
        user.saveEventually()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }



}
