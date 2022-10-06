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
            SettiongViewController.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date, type: MorningAndNight.morning.rawValue)
            print("아침일기 알람 설정 📍")
            return
        }
    }
    
    static func NDefaultNoti() {
        guard (UserDefaults.standard.string(forKey: "NbtnSelected") != nil) else {
            var date = DateComponents(timeZone: .current)
            date.hour = 22
            date.minute = 0
            SettiongViewController.sendNotification(subTitle: "밤 일기를 쓰러가볼까요?", date: date, type: MorningAndNight.night.rawValue)
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
    
//    func setButtonInCell(cell: SettingAlarmTableViewCell, buttonTag: Int, defaultTitle: String, key: String, title: Setting, action: ((_ sender: UIButton) -> Void)) {
//
//        let btnTitle = UserDefaults.standard.string(forKey: "\(key)")
//        let defaultTitle = defaultTitle
//
//        cell.timeButton.setTitle("\(btnTitle ?? defaultTitle)", for: .normal)
//        cell.timeButton.tag = indexPath.row
//        print(buttonCell.timeButton.tag, indexPath.row, "===================================🔴🔴")
//        cell.subTitle.text = "아침 알림 시간"
//        cell.selectionStyle = .none
//        cell.contentView.backgroundColor = .systemGray6
//        cell.timeButton.addTarget(self, action: #selector(MpopDatePicker), for: .touchUpInside)
//        setButtonConfig(buttonCell.timeButton)
//    }
}

