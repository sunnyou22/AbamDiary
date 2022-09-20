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
      SettiongViewController.notificationCenter.requestAuthorization(options: authorizationOptions) {  success, error in
          
            if success {
                UserDefaults.standard.set(true, forKey: "switch")
                // bool을 전역변수로 만들고 toggle로 변경해줌 -> 이 변수를 위의 true자리에 넣는것...?
                SettiongViewController.autorizationSwitchModel.isValid.value = true
                print("노티푸시혀용!!!뷰컨")
            } else {
                print("🔴====> 노티푸시실패")
                print(error?.localizedDescription)
                UserDefaults.standard.set(false, forKey: "switch")
                SettiongViewController.autorizationSwitchModel.isValid.value = false
            }
        }
    }
    
    
    
    func sendNotification(subTitle: String, date: DateComponents) -> Void {
        //노티푸시 구성하기
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "아밤일기"
        notificationContent.subtitle = subTitle
      
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(Date())", content: notificationContent, trigger: trigger)
        
        SettiongViewController.notificationCenter.add(request)
    }
}

