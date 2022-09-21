
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
import RealmSwift

class SettiongViewController: BaseViewController {
    
    var settingView = SettingView()
    let profileImage = "profile.jpg"
    static let notificationCenter =  UNUserNotificationCenter.current()
    var autorizationStatus: Bool?
    static let autorizationSwitchModel = SwitchModel() // 권한에ㅔ 대한 관찰
    
    var tasks: Results<Diary>!
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettiongViewController.autorizationSwitchModel.isValid.bind { bool in
            self.autorizationStatus = bool
        }
        
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
        
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
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
       
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: SettingAlarmTableViewCell.reuseIdentifier, for: indexPath) as? SettingAlarmTableViewCell else {
                    return UITableViewCell()
                }
                
                let btnTitle = UserDefaults.standard.string(forKey: "MbtnSelected")
                let defaultTitle = "00:00"
                buttonCell.timeButton.setTitle("\(btnTitle ?? defaultTitle)", for: .normal)
                
                buttonCell.subTitle.text = "아침 알림 시간"
                
                buttonCell.timeButton.addTarget(self, action: #selector(MpopDatePicker), for: .touchUpInside)
                setButtonConfig(buttonCell.timeButton)
                
                return buttonCell
            } else if indexPath.row == 1 {
                guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: SettingAlarmTableViewCell.reuseIdentifier, for: indexPath) as? SettingAlarmTableViewCell else {
                    return UITableViewCell()
                }
                
                let btnTitle = UserDefaults.standard.string(forKey: "NbtnSelected")
                let defaultTitle = "00:00"
                buttonCell.timeButton.setTitle("\(btnTitle ?? defaultTitle)", for: .normal)
                
              
                buttonCell.subTitle.text = "밤 알림 시간"
               
                setButtonConfig(buttonCell.timeButton)
                
                buttonCell.timeButton.addTarget(self, action: #selector(NpopDatePicker), for: .touchUpInside)
                
                return buttonCell
                
            } else if indexPath.row == 2 {
                guard let switchCell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchTableViewCell.reuseIdentifier, for: indexPath) as? SettingSwitchTableViewCell else {
                    return UITableViewCell()
                }
                
                switchCell.subTitle.text = "알림받기"
                
                SettingSwitchTableViewCell.notificationSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
                return switchCell
            }
            
        } else {
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else { return UITableViewCell() }
            
            defaultCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
            return defaultCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let alert = UIAlertController(title: "알림", message: "정말 모든 데이터를 삭제하시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "네", style: .destructive) {_ in
                    OneDayDiaryRepository.shared.deleteTasks(tasks: self.tasks)
                }
                let cancel = UIAlertAction(title: "아니오", style: .cancel)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                present(alert, animated: true)
            }
        }
    }
    
    //MARK: - 메서드
    func setButtonConfig(_ sender: UIButton) {
        //            "MbtnSelected"
        if UserDefaults.standard.bool(forKey: "switch") == true {
            sender.isUserInteractionEnabled = true
            sender.backgroundColor = Color.BaseColorWtihDark.thineBar
        } else {
            sender.isUserInteractionEnabled = false
            UserDefaults.standard.set(false, forKey: "switch")
            print("======> 🔴 스위치 오프 및 removeAllPendingNotificationRequests")
            sender.backgroundColor = .systemGray4
            sender.setTitle("--:--", for: .normal)
        }
        
    }
    
    //MARK: switch버튼 cell 안에서 처리
    @objc func changeSwitch(_ sender: UISwitch) {
        
        if sender.isOn == true {
            
            sender.setOn(false, animated: true)
            
            let authorizationAlert = UIAlertController(title: "알림권한", message: """
알림을 받기 위해서 시스템 설정에서 권한을 허용하고,
앱을 재시작해주세요.
""", preferredStyle: .alert)
            let authorizationOk = UIAlertAction(title: "확인", style: .default)
            
            authorizationAlert.addAction(authorizationOk)
            
            //MARK: 만약 사용자가 시스템권한을 해제했을 때 대응
            guard autorizationStatus == false else {
                SettiongViewController.requestAutorization()
                UserDefaults.standard.set(true, forKey: "switch")
                sender.setOn(true, animated: true)
                self.settingView.tableView.reloadData()
                return
            }
            present(authorizationAlert, animated: true)
            
        } else if sender.isOn == false {
            
            sender.setOn(true, animated: true) // 2
            let alert = UIAlertController(title: "알림해제", message: "알림을 받지 않으시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { _ in
              
                SettiongViewController.notificationCenter.removeAllPendingNotificationRequests()
                UserDefaults.standard.set(false, forKey: "switch")
                UserDefaults.standard.removeObject(forKey: "MbtnSelected")
                UserDefaults.standard.removeObject(forKey: "NbtnSelected")
                sender.setOn(false, animated: true) // 4
                self.settingView.tableView.reloadData()
            }
            
            let cancel = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
          
            present(alert, animated: true)

        }
    }
    
    //MARK: 프로필 사진 바꾸기
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
    
    @objc func MpopDatePicker(_ sender: UIButton) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.string(from: datePicker.date)
        
        let dateChooseAlert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        dateChooseAlert.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(dateChooseAlert.view.snp.centerX)
            make.width.equalTo(dateChooseAlert.view.snp.width).multipliedBy(0.6)
            make.height.equalTo(datePicker.snp.width)
            make.bottom.equalTo(dateChooseAlert.view.snp.bottom).offset(-60)
        }
        
        //MARK: 선택완료버튼 클릭
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateStringFormatter.string(from: datePicker.date), forKey: "MbtnSelected") //데이트피커가 선택한 날짜
            let dateString = UserDefaults.standard.string(forKey: "MbtnSelected")
            sender.setTitle(dateString, for: .normal)
            print("========>", "\(datePicker.date)")
            
            var date = DateComponents(timeZone: .current)
            
            var Marray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
            
            UserDefaults.standard.set(Marray, forKey: "Mdate")
            
            Marray = UserDefaults.standard.array(forKey: "Mdate") as? [Int] ?? [Int]()
            print("key: Mdate 유저디폴트: 버튼이 선택? 값이 받아왔나!!??", Marray)
            
            date.hour = Marray[0]
            date.minute = Marray[1]
            
            self.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date)
            print("아침일기 알람 설정 📍")
            
        }
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
    
//        let height = NSLayoutConstraint(item: dateChooseAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
//        let width = NSLayoutConstraint(item: dateChooseAlert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
//        dateChooseAlert.view.addConstraint(height)
//        dateChooseAlert.view.addConstraint(width)
//        dateChooseAlert.view.add
        present(dateChooseAlert, animated: true)
    }
    
    @objc func NpopDatePicker(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.string(from: datePicker.date)
        
        let dateChooseAlert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        dateChooseAlert.view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.centerX.equalTo(dateChooseAlert.view.snp.centerX)
            make.width.equalTo(dateChooseAlert.view.snp.width).multipliedBy(0.6)
            make.height.equalTo(datePicker.snp.width)
            make.bottom.equalTo(dateChooseAlert.view.snp.bottom).offset(-60)
        }
        
        
        //MARK: 선택완료버튼 클릭
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateStringFormatter.string(from: datePicker.date), forKey: "NbtnSelected")
            let dateString = UserDefaults.standard.string(forKey: "NbtnSelected")
            sender.setTitle(dateString, for: .normal)
            print("========>", "\(datePicker.date)")
            
            var date = DateComponents(timeZone: .current)
            var Narray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
            
            UserDefaults.standard.set(Narray, forKey: "Ndate")
            Narray = UserDefaults.standard.array(forKey: "Ndate") as? [Int] ?? [Int]()
            print("key: Ndate 유저디폴트: 버튼이 선택? 값이 받아왔남📍", Narray)
            
            date.hour = Narray[0]
            date.minute = Narray[1]
            
            self.sendNotification(subTitle: "밤일기를 쓰러가볼까요?", date: date)
            print("밤일기 알람 설정 📍")
        }
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
       
        
        present(dateChooseAlert, animated: true)
    }
}

