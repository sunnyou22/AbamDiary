//
//  BaseTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configuration()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() { }
    func setConstraints() { }
    
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}
