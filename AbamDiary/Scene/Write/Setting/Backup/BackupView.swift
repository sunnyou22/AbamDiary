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
앱 삭제시 백업파일이 함께 삭제되기 때문에 파일앱 등 별도의 저장소에 관리하는 것을 권장드립니다 :)

파일 복구 시 아밤일기의 데이터가 아닌 경우 기존 데이터가 손실 될 위험이 있습니다.
"""
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
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
