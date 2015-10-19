//
//  AppDelegate.swift
//  Kiss
//
//  Created by thieblin on 10/27/14.
//  Copyright (c) 2014 actimust. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FBLoginView.self
        FBProfilePictureView.self
        
        Parse.setApplicationId("", clientKey: "")
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            
            var notificationType: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        
            var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        
        }
        else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert | UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound)
        }
        
        if launchOptions != nil {
            let payload: NSDictionary = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as NSDictionary
            let aps: NSDictionary = payload.objectForKey("aps") as NSDictionary
            findFriendFromNotification(aps)
            NSNotificationCenter.defaultCenter().postNotificationName("notificationObserver", object: nil)
        }
        
        return true
    }
    
    func findFriendFromNotification(payload: NSDictionary){
        
        let friendName: String? = payload.objectForKey("alert") as String?
        
        if friendName != nil {
            NSUserDefaults.standardUserDefaults().setObject(friendName, forKey: "friendFromNotif")
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
        
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var installation: PFInstallation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveEventually()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        let currentInstallation = PFInstallation.currentInstallation()
        if currentInstallation.badge != 0 {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let payload: NSDictionary = userInfo["aps"] as NSDictionary
        
        findFriendFromNotification(payload)
        
        NSNotificationCenter.defaultCenter().postNotificationName("notificationObserver", object: nil)
        
        completionHandler(UIBackgroundFetchResult.NoData)
    }

}

