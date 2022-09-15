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
    
    let baseView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
       
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.label_14, weight: .ultraLight)
        view.text = "88:88"
        
        return view
    }()
    
    var diaryLabel: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.label_13, weight: .regular)
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 셀 레이아웃 잡기
    override func configuration() {
        contentView.addSubview(baseView)
        [systemImageView, dateLabel, diaryLabel].forEach { baseView.addSubview($0) }
    }

    override func setConstraints() {

        baseView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
        }
        
        systemImageView.snp.makeConstraints { make in
            make.centerY.equalTo(baseView.snp.centerY).offset(-8)
            make.leading.equalTo(baseView.snp.leading).offset(20)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.078)
            make.height.equalTo(systemImageView.snp.height).multipliedBy(1)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(systemImageView.snp.centerX)
            make.top.equalTo(systemImageView.snp.bottom).offset(8)
        }

        diaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(baseView.snp.centerY)
            make.leading.equalTo(systemImageView.snp.trailing).offset(20)
            make.trailing.equalTo(baseView.snp.trailing).offset(-16)

        }
    }
    
//    MARK: cellForRowAt에 적용시키기
    func setMornigAndNightConfig(index: Int) {
        
        baseView.backgroundColor = Color.BaseColorWtihDark.setCellBackgroundColor(type: .allCases[index])
        diaryLabel.textColor = Color.BaseColorWtihDark.setDiaryInCell(type: .allCases[index])
        dateLabel.textColor = Color.BaseColorWtihDark.setDiaryInCell(type: .allCases[index])
        MorningAndNight.allCases[index].setsymbolImage(systemImageView)
        systemImageView.tintColor = Color.BaseColorWtihDark.setSymbolInCell(type: .allCases[index])
    }
}
