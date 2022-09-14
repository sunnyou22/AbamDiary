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
        view.font = UIFont.systemFont(ofSize: FontSize.subTitle_16, weight: .light) // 이탈릭체 적용
        view.text = "888888888888"
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
        view.backgroundColor = .brown
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .light)
        view.textColor = UIColor(hex: "#4B4335")
        return view
    }()
    
    override func configuration() {
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
        [dateLabel, sectionBar, textView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(48)
            make.leading.equalTo(self.snp.leading).offset(20)
        }
        
        sectionBar.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(0)
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.height.equalTo(1)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }
   
    //placeholder메서드
    @discardableResult
    func setWriteVCPlaceholder(type: MorningAndNight) -> String {
        var text: String = "일기를 작성해보세요!"
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            switch type {
            case .morning:
                text = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
                textView.text = text
                
            case .night:
                text = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
                textView.text = text
                
            }
        }
        return text
    }
}



