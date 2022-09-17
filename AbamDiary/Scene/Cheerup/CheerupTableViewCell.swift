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
        view.backgroundColor = .clear
        view.textAlignment = .center
        return view
    }()
    
    let labelContainView: UIView = {
      let view = UIView()
        view.backgroundColor = .clear
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
       
        [labelContainView, dateLabel, sectionView, message].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.center.equalTo(labelContainView.snp.center)
        }
        
        labelContainView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.width.equalTo(80)
        }
//
        sectionView.snp.makeConstraints { make in
            make.leading.equalTo(labelContainView.snp.trailing).offset(0)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges)
            make.width.equalTo(1)
        }
//
        message.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(sectionView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing)

        }
    }
}
