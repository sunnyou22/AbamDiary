//
//  SettingAlarmTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/20.
//

import UIKit

class SettingAlarmTableViewCell: BaseTableViewCell {
    
    let subTitle: UILabel = {
        let view = UILabel()
        view.text = "d"
        return view
    }()
    
    let timeButton: UIButton = {
        let view = UIButton()
     
        view.backgroundColor = .systemGray4
        
        DispatchQueue.main.async {
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = view.frame.height / 2
        }
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
        
        [subTitle, timeButton].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
       
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        timeButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(timeButton.snp.height).multipliedBy(2.4)
            make.height.equalTo(40)
        }
    }
    
  
//    func setTest(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell.
//    }
}
