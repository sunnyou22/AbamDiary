//
//  CheerupTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/17.
//

import Foundation
import UIKit
import SnapKit

class CheerupTableViewCell: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        view.textAlignment = .center
        return view
    }()
    
    let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
    
    let message: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        view.textAlignment = .center
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
        
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.width.equalTo(60)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        sectionView.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(-12)
        }
        
        message.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(sectionView.snp.trailing)
            make.trailing.equalTo(contentView.snp.leading)
        }
    }
}
