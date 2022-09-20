//
//  SettiongViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit
import Toast
import SnapKit
import UserNotifications

class SettiongViewController: BaseViewController {
    
    var settingView = SettingView()
    let profileImage = "profile.jpg"
  static let notificationCenter =  UNUserNotificationCenter.current()
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
        
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        
        settingView.changeButton.addTarget(self, action: #selector(changeProfileButtonClicked), for: .touchUpInside)

        //MARK: 프로필 이미지
        settingView.profileimageView.image = loadImageFromDocument(fileName: profileImage)
    }
}

//MARK: - 테이블 그리기
extension SettiongViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Setting.allCases[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases[section].subTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        settingView.frame.size.height * 0.08 // 고정값으로 빼기
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        
//        defaultCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
        
        if indexPath.section == 0 {
           if indexPath.row == 0 {
              let buttonCell = SettingAlarmTableViewCell()
    
               buttonCell.tag = 0
               let title = UserDefaults.standard.string(forKey: "\(buttonCell.tag)")
                buttonCell.subTitle.text = "아침 알림 시간"
                buttonCell.timeButton.setTitle(title, for: .normal)
               buttonCell.timeButton.setTitle(title, for: .normal)
               
               buttonCell.timeButton.addTarget(self, action: #selector(popDatePicker), for: .touchUpInside)
               
               setButtonConfig(buttonCell.timeButton, by: SettingSwitchTableViewCell.notificationSwitch)
                return buttonCell
            } else if indexPath.row == 1 {
               let buttonCell = SettingAlarmTableViewCell()
                buttonCell.tag = 1
                let title = UserDefaults.standard.string(forKey: "1")
                buttonCell.subTitle.text = "밤 알림 시간"
                buttonCell.timeButton.setTitle(title, for: .normal)
                setButtonConfig(buttonCell.timeButton, by: SettingSwitchTableViewCell.notificationSwitch)
                buttonCell.timeButton.addTarget(self, action: #selector(popDatePicker), for: .touchUpInside)
                return buttonCell
            } else if indexPath.row == 2 {
                let switchCell = SettingSwitchTableViewCell()
                
                switchCell.subTitle.text = "알림받기"
                switchCell.notificationSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
                return switchCell
            }
        } else {
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else { return UITableViewCell() }
            return defaultCell
        }
        
      return UITableViewCell()
        }
    
    
    
    //cell 안에서 처리
    @objc func changeSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            SettiongViewController.requestAutorization()
        } else {
            SettiongViewController.notificationCenter.removeAllPendingNotificationRequests()
        }
    }
    
    @objc func changeProfileButtonClicked() {
        let alert = UIAlertController(title: nil, message: "프로필 사진 변경하기", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        let cameraButton = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            
            self?.presentCamara()
        }
        
        let photoLibrary = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.presentAlbum()
        }
        
        let delete = UIAlertAction(title: "현재 사진 삭제", style: .default) { [weak self] _ in
            guard let image = self?.profileImage else {
                return
            }
            self?.removeImageFromDocument(fileName: image)
            self?.settingView.profileimageView.image = UIImage(systemName: "person")
        }
        
        alert.addAction(delete)
        alert.addAction(cameraButton)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: 데이트 피커
extension SettiongViewController {
    
    @objc func popDatePicker(_ sender: UIButton) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.string(from: datePicker.date)


        print("========> 유저디폴트 키값", "\(sender.tag)")
        
        let dateChooseAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        dateChooseAlert.view.addSubview(datePicker)
        
        //MARK: 선택완료버튼 클릭
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateStringFormatter.string(from: datePicker.date), forKey: "\(sender.tag)")
            let dateString = UserDefaults.standard.string(forKey: "\(sender.tag)")
            sender.setTitle(dateString, for: .normal)
            print("========>", "\(datePicker.date)")
            
            if sender.tag == 0 {
                var date = DateComponents(timeZone: .current)
                var Marray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
             
                UserDefaults.standard.set(Marray, forKey: "Mdate")
                Marray = UserDefaults.standard.array(forKey: "Mdate") as? [Int] ?? [Int]()
            
                date.hour = Marray[0]
                date.minute = Marray[1]
                
                self.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date)
                
                print("아침 일기 알람 설정 📍")
            } else if sender.tag == 1 {
                var date = DateComponents(timeZone: .current)
                var Narray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
             
                UserDefaults.standard.set(Narray, forKey: "Ndate")
                Narray = UserDefaults.standard.array(forKey: "Ndate") as? [Int] ?? [Int]()
            
                date.hour = Narray[0]
                date.minute = Narray[1]
                
                self.sendNotification(subTitle: "밤일기를 쓰러가볼까요?", date: date)
                print("밤일기 알람 설정 📍")
            }
            
        }
        
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
        
        let height : NSLayoutConstraint = NSLayoutConstraint(item: dateChooseAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooseAlert.view.addConstraint(height)
        
        present(dateChooseAlert, animated: true)
    }
}
