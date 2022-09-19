//
//  SettiongViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit
import Toast
import SnapKit

class SettiongViewController: BaseViewController {
    
    var settingView = SettingView()
    let profileImage = "profile.jpg"
    let notificationCenter =  UNUserNotificationCenter.current()
    
    //MARK: 스위치 넣어주기
    let notificationSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()
    
    let goBackUPVCImage: UIImageView = {
        let view = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        view.image = UIImage(systemName: "chevron.forward", withConfiguration: config)
//        view.backgroundColor = .systemBlue
        return view
    }()
    
    let morningNotoTime: UIButton = {
        let view = UIButton()
        view.tag = 0
        let title = UserDefaults.standard.string(forKey: "\(view.tag)")
        view.setTitle(title, for: .normal)
        
        view.backgroundColor = .systemGray4
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 16
        }
        return view
    }()
    
    let nigntNotiTime: UIButton = {
        let view = UIButton()
        view.tag = 1
        let title = UserDefaults.standard.string(forKey: "\(view.tag)")
        view.setTitle(title, for: .normal)
        
        view.backgroundColor = .systemGray4
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 16
        }
        return view
    }()
    
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
        
        morningNotoTime.addTarget(self, action: #selector(popDatePicker), for: .touchUpInside)
       
        
        nigntNotiTime.addTarget(self, action: #selector(popDatePicker), for: .touchUpInside)
      
    }
}

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.subTitle.text = Setting.allCases[indexPath.section].subTitle[indexPath.row]
        
        //메서드 따로 빼기
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.contentView.addSubview(morningNotoTime)
                morningNotoTime.snp.makeConstraints { make in
                    make.trailing.equalTo(cell.contentView.snp.trailing).offset(-20)
                    make.centerY.equalTo(cell.contentView.snp.centerY)
                    make.width.equalTo(morningNotoTime.snp.height).multipliedBy(2.4)
                    make.verticalEdges.equalTo(cell.contentView.snp.verticalEdges).inset(16)
                }
            }
                if indexPath.row == 1 {
                    cell.contentView.addSubview(nigntNotiTime)
                    nigntNotiTime.snp.makeConstraints { make in
                        make.trailing.equalTo(cell.contentView.snp.trailing).offset(-20)
                        make.centerY.equalTo(cell.contentView.snp.centerY)
                        make.width.equalTo(nigntNotiTime.snp.height).multipliedBy(2.4)
                        make.verticalEdges.equalTo(cell.contentView.snp.verticalEdges).inset(16)
                    }
                }
                if indexPath.row == 2 {
                    cell.contentView.addSubview(notificationSwitch)
                    notificationSwitch.snp.makeConstraints { make in
                        make.trailing.equalTo(cell.contentView.snp.trailing).offset(-28)
                        make.centerY.equalTo(cell.contentView.snp.centerY)
                    }
                }
            
            } else if indexPath.section == 1 {
                if indexPath.row == 2 {
                    //didSelect로 화면 넘어가는거 구현하기
                    cell.contentView.addSubview(goBackUPVCImage)
                    goBackUPVCImage.snp.makeConstraints { make in
                        make.centerY.equalTo(cell.contentView.snp.centerY)
                        make.trailing.equalTo(cell.contentView.snp.trailing).offset(-28)
                }
            }
        }
        return cell
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
        
        let dateString = DateFormatter()
        dateString.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateString.dateFormat = "hh:mm"
//        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        dateString.string(from: datePicker.date)
//        let timeStrng = CustomFormatter.setTime(date: datePicker.date)

        print("========> 유저디폴트 키값", "\(sender.tag)")
        
        let dateChooseAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        dateChooseAlert.view.addSubview(datePicker)
        
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateString.string(from: datePicker.date), forKey: "\(sender.tag)")
            let test = UserDefaults.standard.string(forKey: "\(sender.tag)")
            sender.setTitle(test, for: .normal)
            print("========>", "\(datePicker.date)")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        dateChooseAlert.addAction(selection)
        dateChooseAlert.addAction(cancel)
        
        let height : NSLayoutConstraint = NSLayoutConstraint(item: dateChooseAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooseAlert.view.addConstraint(height)
        
        present(dateChooseAlert, animated: true)
        
        
        //MARK: 노티 Test
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: Date()), repeats: true)
    }
    
    @objc func changeSwitch(_ sender: UISwitch) {
        requestAutorization(sendNotification(title: "아밤일기", subTitle: "아침일기를 쓰러가볼까요?", timeInterval: <#T##Double#>))
        requestAutorization(sendNotification(title: "아밤일기", subTitle: "밤일기를 쓰러가볼까요?", timeInterval: <#T##Double#>))
    }
}
