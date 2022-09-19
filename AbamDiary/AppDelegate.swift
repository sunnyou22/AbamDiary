//
//  AppDelegate.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/09.
//

import UIKit
import UserNotifications

 @main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //2. 노티제거
        UNUserNotificationCenter.current().removeAllDeliveredNotifications() // 노티에서 열기를 클릭하거나 그냥 앱을 다시 들어왓을 때 이걸 써주지 않아도 사라지던데 왜 필요한지 다시 설명듣기.. // 생명주기에 다라 다름
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self // 인스턴스를 만들필요가 없음
        // 해당클래스의 인스턴스를 자신이 가지고있다는 것을 의미함 //  UNUserNotificationCenterDelegate { // 액션담당

        
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

