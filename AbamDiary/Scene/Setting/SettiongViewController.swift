
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
import Zip

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
                let defaultTitle = "09:00"
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
                let defaultTitle = "22:00"
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
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                clickBackupCell()
            } else if indexPath.row == 1 {
                
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let alert = UIAlertController(title: "알림", message: "정말 모든 데이터를 삭제하시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "네", style: .destructive) {_ in
                    OneDayDiaryRepository.shared.deleteTasks(tasks: self.tasks)
                    self.settingView.makeToast("삭제완료", duration: 0.7, position: .center) { didTap in
                        
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            
                let cancel = UIAlertAction(title: "아니오", style: .cancel)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                    self.present(alert, animated: true)
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

//MARK: - 데이트 피커
extension SettiongViewController {
    
    //MARK: 아침 데이트피커 버튼 누름
    @objc func MpopDatePicker(_ sender: UIButton) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat으로 나중에 빼기
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.string(from: datePicker.date)
        
        let dateChooseAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let contentVC = UIViewController()
        contentVC.view = datePicker
        contentVC.preferredContentSize.height = 200
        dateChooseAlert.setValue(contentVC, forKey: "contentViewController")
        
        //MARK: 선택완료버튼 클릭
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateStringFormatter.string(from: datePicker.date), forKey: "MbtnSelected") //데이트피커가 선택한 날짜
            let dateString = UserDefaults.standard.string(forKey: "MbtnSelected")
            
            // 버튼 타이틀에 데이터피커의 값을 넣어주기 포맷터
            sender.setTitle(dateString, for: .normal)
            print("========>", "\(datePicker.date)")
            
            var date = DateComponents(timeZone: .current)
            
            //h m가 int로 변환되서 배열로 넣어줌 -> 데이트 컴포넌트를 위해서
            var Marray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
            
            // 유저가 설정한 시간에 대한 데이트컴포넌트 배열을 유저디폴트에 저장해줌
            UserDefaults.standard.set(Marray, forKey: "Mdate")
            print(Marray)
            Marray = UserDefaults.standard.array(forKey: "Mdate") as? [Int] ?? [Int]()
            print("key: Mdate 유저디폴트: 버튼이 선택? 값이 받아왔나!!??", Marray)
            
            date.hour = Marray[0]
            date.minute = Marray[1]
            
            SettiongViewController.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date)
            print("아침일기 알람 설정 📍")
            
        }
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
        
        present(dateChooseAlert, animated: true)
    }
    
    //MARK: 저녁 데이트피커 버튼 누름
    @objc func NpopDatePicker(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "hh:mm"
        dateStringFormatter.string(from: datePicker.date)
        
        let dateChooseAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let contentVC = UIViewController()
        contentVC.view = datePicker
        contentVC.preferredContentSize.height = 200
        dateChooseAlert.setValue(contentVC, forKey: "contentViewController")
        
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
            
            SettiongViewController.sendNotification(subTitle: "밤일기를 쓰러가볼까요?", date: date)
            print("밤일기 알람 설정 📍")
        }
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
        
        
        present(dateChooseAlert, animated: true)
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
                //                SettiongViewController.requestAutorization()
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
                //                UserDefaults.standard.removeObject(forKey: "MbtnSelected")
                //                UserDefaults.standard.removeObject(forKey: "NbtnSelected")
                sender.setOn(false, animated: true) // 4
                self.settingView.tableView.reloadData()
            }
            
            let cancel = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true)
            
        }
    }
    
    //MARK: 백업복구
    
    func clickBackupCell() {
        do {
            try saveEncodedDiaryToDocument(tasks: tasks)
            
            let backupFilePth = try createBackupFile()
            
            try showActivityViewController(backupFileURL: backupFilePth)
            
            fetchDocumentZipFile()
        }
        catch {
            print("압축에 실패하였습니다")
        }
    }
    
    func clickRestoreCell() {
        do {
            
            let doucumentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
            doucumentPicker.delegate = self
            doucumentPicker.allowsMultipleSelection = false
            self.present(doucumentPicker, animated: true)
         
            try restoreRealmForBackupFile()
            
            let backupFilePth = try createBackupFile()
            
            try showActivityViewController(backupFileURL: backupFilePth)
            
            fetchJSONData()
        }
        catch {
            print("압축에 실패하였습니다")
        }
    }
}

extension SettiongViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐머트픽커 닫음", #function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) { // 어떤 압축파일을 선택했는지 명세
        
        guard let selectedFileURL = urls.first else {
            print("선택하진 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        //sandboxFileURL 단지 경로
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) //lastPathComponent: 경로의 마지막 구성요소 SeSACDiary_1.zip, 그니까 마지막 path를 가져오는 것 이것과 도큐먼트의 url의 path와 합쳐주는 것
        
        // 여기서 sandboxFileURL경로있는지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("encodedData.json.zip")
            
            do {
                try unzipFile(fileURL: fileURL, documentURL: path)
            } catch {
                print("압축풀기 실패 다 이놈아~~~")
            }
            
            
        } else {
            
            do {
                //파일 앱의 zip -> 도큐먼트 폴더에 복사(at:원래경로, to: 복사하고자하는 경로) / sandboxFileURL -> 걍 경로
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                do {
                    try unzipFile(fileURL: fileURL, documentURL: path)
                } catch {
                    print("압축풀기 실패 다 이놈아~~~")
                }
            } catch {
                print("🔴 압축 해제 실패")
            }
        }
    }
}
