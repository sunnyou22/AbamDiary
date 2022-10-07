//
//  BackupView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/01.
//

import UIKit
import SnapKit

class BackupView: BaseView {
    
    let notiLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = """
백업파일 생성 시 앱 내부 저장소에 자동저장되며, 앱 삭제 시 함께 삭제됩니다.
복구 시 파일앱의 벡압파일을 기준으로 복구됩니다 :)

아래 항목의 파일명과 파일앱에서 불러오는 파일명이 다를 경우
두 파일 모두 앱 내 저장소에 보관되며 아래 항목에 표시됩니다.

:( 복구과정에서 아밤일기의 데이터가 아닌 경우 현재 앱의 데이터가 유실 될 위험이 있습니다.
"""
        view.font = UIFont.systemFont(ofSize: 13, weight: .light)
        view.textColor = .systemGray
        return view
    }()
    
    let backupFileButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업", for: .normal)
        view.backgroundColor = .systemGray6
        view.setTitleColor(Color.BaseColorWtihDark.date, for: .normal)
       
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 20
        }
        
        return view
    }()
    
    let restoreFileButton: UIButton = {
        let view = UIButton()
        view.setTitle("복구", for: .normal)
        view.backgroundColor = .systemGray6
        view.setTitleColor(Color.BaseColorWtihDark.date, for: .normal)
        
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 20
        }
        
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(SettingDefaultTableViewCell.self, forCellReuseIdentifier: SettingDefaultTableViewCell.reuseIdentifier)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            
            view.clipsToBounds = true
            view.layer.cornerRadius = 20
        }
        view.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configuration() {
        [backupFileButton, restoreFileButton].forEach { stackView.addArrangedSubview($0) }
        [notiLabel, stackView, tableView].forEach { self.addSubview($0)  }
    }
    
    override func setConstraints() {
        
        notiLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(notiLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backupFileButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
