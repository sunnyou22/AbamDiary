//
//  CheerupTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/17.
//

import UIKit
import SnapKit

class CheerupTableViewCell: BaseTableViewCell {
    
    let title: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
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
        
        [labelContainView, title, sectionView, subTitle].forEach { contentView.addSubview($0) }
        
        
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
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
        subTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(sectionView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing)
            
        }
    }
    
    func setCheerupTableCellConfig(leftLabel: UILabel, right: UILabel) {
        title.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        title.textAlignment = .center
        
        subTitle.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        subTitle.textAlignment = .center
    }
    
    func setSettingTableCellConfig(leftLabel: UILabel, right: UILabel) {
        title.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        title.textAlignment = .center
        
        subTitle.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subTitle.textAlignment = .left
    }
    
//    func setTest(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell.
//    }
}
