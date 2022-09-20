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
        view.text = "rdadfa"
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
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        
        [subTitle, morningNotoTime, nigntNotiTime].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
       
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        morningNotoTime.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(morningNotoTime.snp.height).multipliedBy(2.4)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(16)
        }
        
        nigntNotiTime.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(nigntNotiTime.snp.height).multipliedBy(2.4)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(16)
        }
    }
    
  
//    func setTest(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell.
//    }
}
