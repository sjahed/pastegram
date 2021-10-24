//
//  AppDelegate.swift
//  pastegram
//
//  Created by Sayed Jahed Hussini on 10/10/21.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    //APP ID JSvzvSZHeVN0xvQ6sEugPl0Ncsh5lRZXuy1Kq3Am
    //Client Key zegwXMVZlziCcN8m2WORWLTlO4qCTFoJd18VR0HB
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let parseConfig = ParseClientConfiguration{
            $0.applicationId = "JSvzvSZHeVN0xvQ6sEugPl0Ncsh5lRZXuy1Kq3Am"
            $0.clientKey = "zegwXMVZlziCcN8m2WORWLTlO4qCTFoJd18VR0HB"
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: parseConfig)
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

