//
//  NoficationPush + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit

extension SettiongViewController {
    
    static func requestAutorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        SettiongViewController.notificationCenter.requestAuthorization(options: authorizationOptions) {  success, error in
            
            if success {
                UserDefaults.standard.set(true, forKey: "switch")
                
                SettiongViewController.MDefaultNoti()
                SettiongViewController.NDefaultNoti()
                
                SettiongViewController.sendBlueBirdNotification(context: "test블루버드 노티피케이션")
                
                SettiongViewController.autorizationSwitchModel.isValid.value = true
                
            } else {
                
                UserDefaults.standard.set(false, forKey: "switch")
                SettiongViewController.autorizationSwitchModel.isValid.value = false
            }
        }
    }
    
    
    static func MDefaultNoti() {
        
        guard (UserDefaults.standard.string(forKey: "MbtnSelected") != nil) else {
            var date = DateComponents(timeZone: .current)
            date.hour = 9
            date.minute = 0
            SettiongViewController.sendNotification(subTitle: "오늘 아침일기를 작성하셨나요?", date: date, type: MorningAndNight.morning.rawValue)
            print("아침일기 알람 설정 📍노티 샌드")
            return
        }
    }
    
    static func NDefaultNoti() {
        guard (UserDefaults.standard.string(forKey: "NbtnSelected") != nil) else {
            var date = DateComponents(timeZone: .current)
            date.hour = 22
            date.minute = 0
            SettiongViewController.sendNotification(subTitle: "오늘 밤 일기를 작성하셨나요?", date: date, type: MorningAndNight.night.rawValue)
            print("밤일기 알람 설정 📍노티 샌드")
            return
        }
    }
    
    static func sendNotification(subTitle: String, date: DateComponents, type: Int) -> Void {
        //노티푸시 구성하기
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "아밤일기"
        notificationContent.subtitle = subTitle
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(type)", content: notificationContent, trigger: trigger)
        
        SettiongViewController.notificationCenter.add(request)
    }
    
    static func sendBlueBirdNotification(context: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = .default
        notificationContent.title = "아밤일기"
        notificationContent.body = context
        
        let imageName = "icon-park-solid_bird-1"
        guard let imgaeURL = Bundle.main.url(forResource: imageName, withExtension: ".png") else { return }
        
        do {
            let attachment = try UNNotificationAttachment(identifier: imageName, url: imgaeURL, options: .none)
            notificationContent.attachments = [attachment]
        } catch {
            print("attachment실패")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: notificationContent, trigger: trigger)
        
        SettiongViewController.notificationCenter.add(request, withCompletionHandler: nil)
    }
}
