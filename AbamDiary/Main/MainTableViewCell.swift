//
//  MainTableViewCell.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import SnapKit

class MainTableViewCell: BaseTableViewCell {
   
    //MARK: 셀 내부 뷰 설정
    let systemImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.label_12, weight: .ultraLight)
        
        return view
    }()
    
    let diaryLabel: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.label_13, weight: .ultraLight)
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    //MARK: 셀 레이아웃 잡기
    override func configuration() {
        [systemImageView, diaryLabel, diaryLabel].forEach { contentView.addSubview($0) }
       
        setupShadow()
    }
    
    override func setConstraints() {
        
        systemImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(systemImageView.snp.centerY)
            make.top.equalTo(systemImageView.snp.bottom).offset(4)
        }
        
        diaryLabel.snp.makeConstraints { make in
            make.centerX.equalTo(systemImageView.snp.centerX)
            make.leading.equalTo(systemImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(16)
            
        }
    }
    
    //MARK: cellForRowAt에 적용시키기
    func setMornigAndNightConfig(index: Int) {
        
        contentView.backgroundColor = Color.BaseColorWtihDark.setCellBackgroundColor(type: .allCases[index])
        diaryLabel.textColor = Color.BaseColorWtihDark.setDiaryInCell(type: .allCases[index])
        dateLabel.textColor = Color.BaseColorWtihDark.setDiaryInCell(type: .allCases[index])
        MorningAndNight.allCases[index].setsymbolImage(systemImageView)
        systemImageView.tintColor = Color.BaseColorWtihDark.setSymbolInCell(type: .allCases[index])
    }
}
