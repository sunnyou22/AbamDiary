//
//  NoficationPush + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit

extension SettiongViewController {
    
    //send에 sendNotification이 함수 담기
    func requestAutorization(_ send: ()) {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization(options: authorizationOptions) {  success, error in
            if success {
                send
            } else {
                print("🔴====> 노티푸시 실패")
            }
        }
    }
    
    func sendNotification(title: String, subTitle: String, timeInterval: Double) -> Void {
        //노티푸시 구성하기
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
        //        notificationContent.badge -> 할까말까...다마고치앱 확인하기
        
        //언제보낼거?
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        //
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
    }
}

