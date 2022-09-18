//
//  SettiongViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit
import Photos
import PhotosUI

enum Setting: Int, CaseIterable {
    case notification, backup, reset
    
    var leftTitle: String {
        switch self {
        case .notification:
            return "알림"
        case .backup:
            return "백업"
        case .reset:
            return "초기화"
        }
    }
    
    var rightLabel: String {
        switch self {
        case .notification:
            return "  알림받기"
        case .backup:
            return "  백업 및 복구"
        case .reset:
            return "  모든일기 삭제하기"
        }
    }
}

class SettiongViewController: BaseViewController {
    
    var settingView = SettingView()
   
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
        //        DispatchQueue.main.async { [self] in
//            let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
//            settingView.profileimageView.image = UIImage(systemName: "camera.fill", withConfiguration: config)
//        }
       
        
        //MARK: 프로필 이미지 test
        settingView.profileimageView.image = loadImageFromDocument(fileName: "profile.jpg")
    }
}

extension SettiongViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        settingView.frame.size.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheerupTableViewCell.reuseIdentifier, for: indexPath) as? CheerupTableViewCell else { return UITableViewCell() }
        
        cell.setSettingTableCellConfig(leftLabel: cell.leftLabel, right: cell.rightLabel)
        
        cell.leftLabel.text = Setting.allCases[indexPath.row].leftTitle
        cell.rightLabel.text = Setting.allCases[indexPath.row].rightLabel
        
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
        
        alert.addAction(cameraButton)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
