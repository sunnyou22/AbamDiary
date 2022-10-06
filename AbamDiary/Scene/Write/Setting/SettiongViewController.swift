
//
//  SettiongViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import MessageUI
import UIKit
import PhotosUI

import Toast
import SnapKit
import UserNotifications
import RealmSwift
import Zip
import AcknowList

class SettiongViewController: BaseViewController {
    
    var settingView = SettingView()
    let profileImage = "profile.jpg"
    static let notificationCenter =  UNUserNotificationCenter.current()
    var autorizationStatus: Bool?
    static let autorizationSwitchModel = SwitchModel() // 권한에ㅔ 대한 관찰
    var configuration = PHPickerConfiguration()
    var tasks: Results<Diary>!
    var cheerupTasks: Results<CheerupMessage>!
    
    override func loadView() {
        self.view = settingView
        DispatchQueue.main.async {
            self.settingView.profileimageView.clipsToBounds = true
            self.settingView.profileimageView.contentMode = .scaleAspectFill
            self.settingView.profileimageView.layer.cornerRadius = self.settingView.profileimageView.frame.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView.tableView.tableHeaderView = settingView.header
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
        cheerupTasks = CheerupMessageRepository.shared.fetchDate(ascending: false)
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
                buttonCell.timeButton.tag = indexPath.row
                if  buttonCell.timeButton.tag == 0 {
                    
                    let btnTitle = UserDefaults.standard.string(forKey: "MbtnSelected")
                    let defaultTitle = "09:00"
                    
                    buttonCell.timeButton.setTitle("\(btnTitle ?? defaultTitle)", for: .normal)
                    print(buttonCell.timeButton.tag, indexPath.row, btnTitle, "===================================🟠")
                    buttonCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
                    buttonCell.selectionStyle = .none
                    buttonCell.contentView.backgroundColor = .systemGray6
                    buttonCell.timeButton.addTarget(self, action: #selector(MpopDatePicker), for: .touchUpInside)
                    setButtonConfig(buttonCell.timeButton)
                }
                
                return buttonCell
                
            } else if indexPath.row == 1 {
                guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: SettingAlarmTableViewCell.reuseIdentifier, for: indexPath) as? SettingAlarmTableViewCell else {
                    return UITableViewCell()
                }
                buttonCell.timeButton.tag = indexPath.row
                
                if  buttonCell.timeButton.tag == 1 {
                    
                    let btnTitle = UserDefaults.standard.string(forKey: "NbtnSelected")
                    let defaultTitle = "22:00"
                    buttonCell.timeButton.setTitle("\(btnTitle ?? defaultTitle)", for: .normal)
                    buttonCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
                    print(buttonCell.timeButton.tag, indexPath.row, btnTitle, "===================================🔴🔴")
                    setButtonConfig(buttonCell.timeButton)
                    buttonCell.contentView.backgroundColor = .systemGray6
                    buttonCell.timeButton.addTarget(self, action: #selector(NpopDatePicker), for: .touchUpInside)
                    buttonCell.selectionStyle = .none
                }
                return buttonCell

            } else if indexPath.row == 2 {
                guard let switchCell = tableView.dequeueReusableCell(withIdentifier: SettingSwitchTableViewCell.reuseIdentifier, for: indexPath) as? SettingSwitchTableViewCell else {
                    return UITableViewCell()
                }
                
                switchCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
                switchCell.contentView.backgroundColor = .systemGray6
                SettingSwitchTableViewCell.notificationSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
                switchCell.selectionStyle = .none
                return switchCell
            }
            
        } else {
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else { return UITableViewCell() }
            defaultCell.selectionStyle = .none
            defaultCell.contentView.backgroundColor = .systemGray6
            defaultCell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
            return defaultCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = BackupViewController()
                transition(vc, transitionStyle: .push)
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
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                guard let url = Bundle.main.url(forResource: "Package", withExtension: "resolved"), let data = try? Data(contentsOf: url), let acknowList = try? AcknowPackageDecoder().decode(from: data) else { return }
                
                let vc = AcknowListViewController()
                vc.acknowledgements = acknowList.acknowledgements
                transition(vc, transitionStyle: .push)
            } else if indexPath.row == 1 {
                     sendMail()
            } else if indexPath.row == 2 {
                moveToWriteReview()
                    }
            }
        }
  
    func moveToWriteReview() {
        
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(1645004739)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        }
    
    }
        
    
    //MARK: - 메서드
    func setButtonConfig(_ sender: UIButton) {
        //            "MbtnSelected"
        if UserDefaults.standard.bool(forKey: "switch") == true {
            sender.isUserInteractionEnabled = true
            sender.backgroundColor = Color.BaseColorWtihDark.alarmBackgroundBorder
            sender.layer.borderColor = Color.BaseColorWtihDark.alarmButtonBorder.cgColor
            sender.layer.borderWidth = 2
        } else {
            sender.isUserInteractionEnabled = false
            UserDefaults.standard.set(false, forKey: "switch")
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
            self?.removeBackupFileDocument(fileName: image)
            self?.settingView.profileimageView.image = UIImage(named: "ABAM")
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
        print("아침일기 알람 설정시작 📍")
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat으로 나중에 빼기
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "H:mm"
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
            
            var date = DateComponents(timeZone: .current)
            
            //h m가 int로 변환되서 배열로 넣어줌 -> 데이트 컴포넌트를 위해서
            var Marray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
            print(dateString, Marray, #function)
            // 유저가 설정한 시간에 대한 데이트컴포넌트 배열을 유저디폴트에 저장해줌
            UserDefaults.standard.set(Marray, forKey: "Mdate")
            Marray = UserDefaults.standard.array(forKey: "Mdate") as? [Int] ?? [Int]()
            
            
            date.hour = Marray[0]
            date.minute = Marray[1]
            
            SettiongViewController.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date, type: MorningAndNight.morning.rawValue)
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
        print("밤 일기 알람 설정시작 📍")
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        //dateformat
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateStringFormatter.dateFormat = "H:mm"
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
            
            var date = DateComponents(timeZone: .current)
            var Narray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
            print(dateString, Narray, #function)
            UserDefaults.standard.set(Narray, forKey: "Ndate")
            Narray = UserDefaults.standard.array(forKey: "Ndate") as? [Int] ?? [Int]()
            
            date.hour = Narray[0]
            date.minute = Narray[1]
            
            SettiongViewController.sendNotification(subTitle: "밤일기를 쓰러가볼까요?", date: date, type: MorningAndNight.night.rawValue)
            print("밤 일기 알람 설정 📍")
        }
        //MARK: cancel버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
        
        present(dateChooseAlert, animated: true)
    }
    
    //MARK: switch버튼 cell 안에서 처리
    @objc func changeSwitch(_ sender: UISwitch) {
        
        if sender.isOn == true { //현재 스위치 상태 1
            
//            sender.setOn(false, animated: true)
            
            let authorizationAlert = UIAlertController(title: "알림권한", message: """
알림을 받기 위해서는 시스템 설정에서
알림을 허용으로 변경해야합니다.
시스템 설정으로 이동하시겠습니까?
(허용한 이후 앱을 껐다 켜주세요!)
""", preferredStyle: .alert)
            let authorizationOk = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.goSettingURL()
            }
            let authorizationcancel = UIAlertAction(title: "아니오", style: .cancel)
            
            authorizationAlert.addAction(authorizationOk)
            authorizationAlert.addAction(authorizationcancel)
            
            //MARK: 만약 사용자가 시스템권한을 해제했을 때 대응
            guard autorizationStatus == false else {
                                SettiongViewController.requestAutorization()
                UserDefaults.standard.set(true, forKey: "switch")
                sender.setOn(true, animated: true)
                self.settingView.tableView.reloadData()
                return
            }
            present(authorizationAlert, animated: true)
            
        } else if sender.isOn == false { // 스위치 끄먄 바로 넘어옴 2
            
            sender.setOn(true, animated: true) // 3
            
            let alert = UIAlertController(title: "알림해제", message: "알림을 받지 않으시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { _ in
                
                SettiongViewController.notificationCenter.removeAllPendingNotificationRequests()
                UserDefaults.standard.set(false, forKey: "switch")
                sender.setOn(false, animated: true) //  5
                self.settingView.tableView.reloadData()
            }
            
            let cancel = UIAlertAction(title: "아니오", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true)
            
        }
    }
    
    func goSettingURL() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            settingView.makeToast("설정창으로 이동할 수 없습니다ㅠㅠ!")
            return
        }
        UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
    }
}

extension SettiongViewController: MFMailComposeViewControllerDelegate {
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["sunnyouyaya22@gmail.com"])
            mail.setSubject("아밤일기 문의 -")
            mail.mailComposeDelegate = self
            self.present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "문의", message: "메일 등록 혹은\nsunnyouyaya22@gmail.com로\n문의해주세요!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            settingView.makeToast("메일 전송을 취소했습니다!", position: .center)
        case .saved:
            settingView.makeToast("메일 전송을 임시 저장했습니다!", position: .center)
        case .sent:
            settingView.makeToast("메일을 전송했습니다!", position: .center)
        case .failed:
            settingView.makeToast("메일 전송을 실패했습니다!", position: .center)
        @unknown default:
            return
        }
        controller.dismiss(animated: true)
    }
}

extension Bundle {
    
    class var appVersion: String {
        if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return value
        }
        return ""
    }
}
