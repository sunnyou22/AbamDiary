//
//  AppDelegate.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/09.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //2. 노티제거
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().delegate = self
    
        FirebaseApp.configure()
        
        UITextField.appearance().tintColor = Color.BaseColorWtihDark.labelColor
        UITextView.appearance().tintColor = Color.BaseColorWtihDark.labelColor
            
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
            SettiongViewController.notificationCenter.delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            SettiongViewController.notificationCenter.requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        //메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        //현재 등록된 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)" - 필요없음
          }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SettiongViewController.notificationCenter.getDeliveredNotifications { list in
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = list.count
                print("\(#function), \(list), 🔴\(list.count)🔴 ===========")
            }
        }
    }
   
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .sound, .badge, .banner])
    }
    
    //  Messaging.messaging().apnsToken -> 파이어베이스
    // 여기에 디바이스 토큰을 할당해줬을 때, 파베가 푸시를 보낼 때 apns한테 이 토큰에게 푸시를 보내고싶다고 하면
    //apns가 이 토큰을 가지고 있는 디바이스한테 푸시를 보냄
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("=================사용자가 푸시를 클릭했습니다")
        
        let id = response.notification.request.identifier
        print(id, "============================")
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        print(viewController)
        
        if id == "0" {
            print("======================", #function)
            if viewController is CalendarViewController {
                let vc = WriteViewController(diarytype: .morning, writeMode: .newDiary)
                // 이부분이 false로 계속 나옴
                print("=================if 안~~~")
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension AppDelegate: MessagingDelegate {
    
    //사용자가 앱을 삭제하거나, 핸드폰 기종을 바꿀 때 등으로 토큰에 대한 정보가 바뀔 때 불리는 메서드
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}

extension UIViewController {
    //현재 뷰를 취상단뷰로 설정해줌
    var topViewController: UIViewController? {
        return self.topViewController(currtentViewController: self)
    }
    
    func topViewController(currtentViewController: UIViewController) -> UIViewController {
        
        //최상탄 뷰컨이 탭바일때
        if let tabBarController = currtentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currtentViewController: selectedViewController)
            
        } else if let navigationController = currtentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currtentViewController: visibleViewController)
            
        } else if let presentedViewController = currtentViewController.presentedViewController {
            return self.topViewController(currtentViewController: presentedViewController)
            
        } else {
           return currtentViewController
        }
    }
}
