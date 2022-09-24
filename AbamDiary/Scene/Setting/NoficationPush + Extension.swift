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
                
                SettiongViewController.MDefaultNoti()
                SettiongViewController.NDefaultNoti()
              
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
    
    
    static func MDefaultNoti() {
        print(UserDefaults.standard.string(forKey: "NbtnSelected"),"timeNoti-밤 노티 기본시간=========") // nil로 들어옴
        
        guard (UserDefaults.standard.string(forKey: "MbtnSelected") != nil) else {
            var date = DateComponents(timeZone: .current)
            date.hour = 9
            date.minute = 0
            print("아침 데이트 컴포넌트 timeNoti", date)
            //            UserDefaults.standard.set([9, 0], forKey: "Mdate")
            SettiongViewController.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date)
            print("아침일기 알람 설정 📍")
            return
        }
    }
    
    static func NDefaultNoti() {
        print(UserDefaults.standard.string(forKey: "NbtnSelected"),"timeNoti-아침 노티 기본시간=========") // nil로 들어옴
        guard (UserDefaults.standard.string(forKey: "NbtnSelected") != nil) else {
            var date = DateComponents(timeZone: .current)
            date.hour = 22
            date.minute = 0
            print("밤 데이트 컴포넌트 timeNoti", date)
            SettiongViewController.sendNotification(subTitle: "밤 일기를 쓰러가볼까요?", date: date)
            print("밤일기 알람 설정 📍")
            return
        }
    }
    
    static func sendNotification(subTitle: String, date: DateComponents) -> Void {
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

