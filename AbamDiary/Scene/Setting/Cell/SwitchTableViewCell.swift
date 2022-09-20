//
//  SettingSwitchTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/20.
//

import UIKit
import SnapKit

class SettingSwitchTableViewCell: BaseTableViewCell {
    
    let subTitle: UILabel = {
        let view = UILabel()
        view.text = "rdadfa"
        return view
    }()
    
    //MARK: 스위치 넣어주기
 static let notificationSwitch: UISwitch = {
        let view = UISwitch()
        view.setOn(UserDefaults.standard.bool(forKey: "switch"), animated: true)
        return view
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        
        [subTitle, SettingSwitchTableViewCell.notificationSwitch].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
       
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        SettingSwitchTableViewCell.notificationSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-28)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
  
//    func setTest(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell.
//    }
}

