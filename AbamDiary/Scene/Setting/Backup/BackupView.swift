//
//  BackupView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/01.
//

import UIKit
import SnapKit

class BackupView: BaseView {
    
    let backupFileNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "백업파일이름을 입력해주세요"
        view.backgroundColor = .brown
        return view
    }()
    
    let backupFileButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업", for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(SettingDefaultTableViewCell.self, forCellReuseIdentifier: SettingDefaultTableViewCell.reuseIdentifier)
        view.backgroundColor = .gray
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
        [backupFileNameTextField, backupFileButton, tableView].forEach { self.addSubview($0)  }
    }
    
    override func setConstraints() {
        backupFileNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28)
            make.leading.equalTo(self.snp.leading).offset(28)
            make.trailing.equalTo(backupFileButton.snp.leading).offset(-16)
        }
        
        backupFileButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-28)
            make.centerY.equalTo(backupFileNameTextField.snp.centerY)
            make.width.equalTo(48)
            make.height.equalTo(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backupFileNameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
