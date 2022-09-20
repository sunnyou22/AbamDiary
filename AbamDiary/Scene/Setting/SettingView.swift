//
//  SettingView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/18.
//

import UIKit
import SnapKit

class SettingView: BaseView {
    
    let profileimageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.contentMode = .scaleAspectFill
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 16
        }
       
        return view
    }()
    
    let changeButton: UIButton = {
       let view = UIButton()
        view.tintColor = .black
        view.setTitle("프로필 사진 바꾸기", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.subTitle_16, weight: .regular)
        view.setTitleColor(.systemBlue, for: .normal)
        view.tintColor = .systemBlue
        
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(SettingDefaultTableViewCell.self, forCellReuseIdentifier: SettingDefaultTableViewCell.reuseIdentifier)

        view.register(SettingAlarmTableViewCell.self, forCellReuseIdentifier: SettingAlarmTableViewCell.reuseIdentifier)
        
        view.register(SettingSwitchTableViewCell.self, forCellReuseIdentifier: SettingSwitchTableViewCell.reuseIdentifier)

        view.isScrollEnabled = true
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorStyle = .singleLine
//        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        [profileimageView, changeButton, tableView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        profileimageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.height.equalTo(profileimageView.snp.width)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(profileimageView.snp.bottom).offset(8)
            make.centerX.equalTo(profileimageView.snp.centerX)
        }
//
        tableView.snp.makeConstraints { make in
            make.top.equalTo(changeButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
