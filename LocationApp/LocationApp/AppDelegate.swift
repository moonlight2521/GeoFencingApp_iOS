//
//  AppDelegate.swift
//  LocationApp
//
//  Created by Zun Lin on 6/14/18.
//  Copyright © 2018 Zun Lin. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
//        UIApplication.shared.cancelAllLocalNotifications()
//
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if !granted {
                print("Something went wrong")
            }
        }
        
        if (launchOptions != nil) {
            NSLog("got remote notification here!")
        } else {
            NSLog("got remote notification as NIL!")
        }

        return true
    }

    func handleEvent(forRegion region: CLRegion!, message: String!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
           // let message = "message"
            window?.rootViewController?.showAlert(withTitle: nil, message: message)
            
        } else {
            // Otherwise push a local notification badge
//            let notification = UILocalNotification()
//            notification.soundName = "Default"
//            UIApplication.shared.presentLocalNotificationNow(notification)
//
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Statues:", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "stuff here!", arguments: nil)
            content.sound = UNNotificationSound.default()
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
            content.categoryIdentifier = "categoryId"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: content.categoryIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                // Handle error
            })
            
        }
        
    }
   
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("App received remote notification.")
        switch application.applicationState {
            
        case .active:
            //app is currently active, can update badges count here
            NSLog("App is currently active")
            break
            
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            NSLog("App is inactive: transitioning from background to foreground")
            break

        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            NSLog("App is completely in background mode")
            break
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, message: "Enter the Region")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region, message: "Exit the Region")
        }
    }
}

