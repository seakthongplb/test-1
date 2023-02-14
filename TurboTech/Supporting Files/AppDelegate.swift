//
//  AppDelegate.swift
//  TurboTech
//
//  Created by sq on 5/19/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//
// S5AZC8X8J7
// APP ID : S5AZC8X8J7.com.turbotech.turbotech-ios
/*
 Name:TurboTech
 Key ID:TWSAK32XLQ
 Services:Apple Push Notifications service (APNs)
 */
import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    static var user : User?
    
    let MAP_API_KEY = "AIzaSyCVnvcyruHSY9h6uVF5-ZXJrAIyRwgvorA"
//    AIzaSyCVnvcyruHSY9h6uVF5-ZXJrAIyRwgvorA
//    AIzaSyDhU0bQuYVB10BrVXgKthlVhPi-GwRCANw
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    lazy var splashImageView : UIImageView = {
        let imageView = UIImageView(frame: self.window!.frame)
        imageView.image = UIImage(named: "circle")
        imageView.backgroundColor = .white
        return imageView
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        if UserDefaults.standard.string(forKey: "LanguageCode") == nil {
            LanguageManager.shared.language = "km"
        }
        
        UITabBar.appearance().barTintColor = TAB.COLOR
        UITabBar.appearance().tintColor = TAB.SELECTED_COLOR
//        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = TAB.UNSELECTED_COLOR.withAlphaComponent(TAB.UISELECTED_ALPHA)
        UITabBarItem.appearance().setTitleTextAttributes([
//            NSAttributedString.Key.foregroundColor: COLOR.WHITE,
                NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [
                    UIFontDescriptor.AttributeName.textStyle: UIFont.TextStyle.headline,
                    UIFontDescriptor.AttributeName.name: UIFontDescriptor(name: "Quicksand-Bold", size: 12)
                ]), size: 12)
        ], for: .normal)
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = COLOR.RED
        navBarAppearance.tintColor = COLOR.WHITE
        navBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: COLOR.WHITE,
                NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(fontAttributes: [
                    UIFontDescriptor.AttributeName.textStyle: UIFont.TextStyle.headline,
                    UIFontDescriptor.AttributeName.name: UIFontDescriptor(name: "Quicksand-bold", size: 20)
                ]), size: 20)
        ]
        navBarAppearance.isTranslucent = true
        
        GMSServices.provideAPIKey(MAP_API_KEY)
        GMSPlacesClient.provideAPIKey(MAP_API_KEY)
        
        FirebaseApp.configure()
        
        // [START message delegate]
        Messaging.messaging().delegate = self
        
        // MARK: - Configure Message
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (status, error) in
                print(error?.localizedDescription ?? "")
            }
        }
//        else {
//            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
        application.registerForRemoteNotifications()
        
        return true
    }
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        print("applicationWillResignActive")
//        self.window?.addSubview(splashImageView)
//    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("applicationDidEnterBackground")
//        self.window?.addSubview(splashImageView)
//    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        // WORK TERMINATE
//        print("applicationWillTerminate")
//    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        self.window?.addSubview(splashImageView)
////        splashImageView.removeFromSuperview()
//    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("applicationDidBecomeActive")
//        self.window?.addSubview(splashImageView)
//    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being crreated.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        MARK: - THIS IS USE FOR Firebase Prod | Deve
//        print("APNs token retrieved: \(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
//        Auth.auth().setAPNSToken(deviceToken, type: .sandbox) // dev mode
//        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        if let messageId = userInfo[gcmMessageIDKey] {
            print("Message ID : ", messageId)
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
//            print("App Delegate can handle url")
            return true
        } else {
//            print("App Delegate cannot handle url")
            return false
        }
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
//      print(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//      print("Firebase registration token: \(fcmToken)")
      
      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
}
