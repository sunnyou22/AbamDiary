//
//  WriteView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation
import UIKit

class WriteView: BaseView {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = Color.BaseColorWtihDark.date
        view.font = UIFont.systemFont(ofSize: 16, weight: .light) // 이탈릭체 적용
        
        return view
    }()
    
    let sectionBar: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
    
    //플레이스 홀더
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = UIColor(hex: "#4B4335")
        return view
    }()
    
    override func configuration() {
        [dateLabel, sectionBar, textView].forEach { self.addSubview($0) }
        textView.text = setPlaceholder(type: "아침") // 뷰컨 나눠서 설정해주기
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(48)
            make.leading.equalTo(self.snp.leading).offset(20)
        }
        
        sectionBar.snp.makeConstraints { make in
            make.trailing.equalTo(dateLabel.snp.leading).offset(20)
            make.centerY.equalTo(dateLabel.snp.centerY)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(48)
            make.leading.equalTo(self.snp.leading).offset(24)
        }
    }
}
