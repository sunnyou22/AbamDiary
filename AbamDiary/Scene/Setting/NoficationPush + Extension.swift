//
//  NoficationPush + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit

extension SettiongViewController {
    
    func requestAutorization(_ send: () -> Void) {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notificationCenter.requestAuthorization { success, error in
            if success {
                
            } else {
                print("🔴====> 노티푸시 실패")
            }
        }
        }
    
    func morningSendNotification(title: String, subTitle: String, timeInterval: Double) {
        
        //노티푸시 구성하기
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subTitle
//        notificationContent.badge -> 할까말까...다마고치앱 확인하기
        
        //언제보낼거?
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        //
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        notificationCenter.add(request)
        }
    }

