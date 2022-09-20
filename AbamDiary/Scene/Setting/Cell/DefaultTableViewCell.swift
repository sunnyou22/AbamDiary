//
//  SettingDefaultTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit
import SnapKit

class SettingDefaultTableViewCell: BaseTableViewCell {
    
    let subTitle: UILabel = {
        let view = UILabel()
        view.text = "rdadfa"
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
        
        [subTitle].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
       
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
    }
//    func setTest(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell.
//    }
}
