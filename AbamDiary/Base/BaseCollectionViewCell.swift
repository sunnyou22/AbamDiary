//
//  BaseCollectionViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/20.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() { }
    func setConstraints() { }
}
