//
//  NoficationPush + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit

extension SettiongViewController {
    
    //send에 sendNotification이 함수 담기
    //거절했을 때의 값을 받아올 수 있나?
  static func requestAutorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
       notificationCenter.requestAuthorization(options: authorizationOptions) {  success, error in
            if success {
                UserDefaults.standard.set(true, forKey: "switch")
                
                print("노티푸시혀용!!!뷰컨")
            } else {
                print("🔴====> 노티푸시실패")
                UserDefaults.standard.set(false, forKey: "switch")
                
            }
        }
    }
    
    func sendNotification(subTitle: String, date: DateComponents) -> Void {
        //노티푸시 구성하기
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "아밤일기"
        notificationContent.subtitle = subTitle
        //        notificationContent.badge -> 할까말까...다마고치앱 확인하기
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: timeInterval), repeats: true)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        //언제보낼거?
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//
        //
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        SettiongViewController.notificationCenter.add(request)
    }
}

