//
//  WriteView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit

class WriteView: BaseView {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(12 * 3.141592653589793 / 180 )), d: 1, tx: 0, ty: 0)
        let desc = UIFontDescriptor.init(name: "Helvetica Neue Light", matrix: matrix)
        view.font = UIFont(descriptor: desc, size: 18)
        view.textColor =  Color.BaseColorWtihDark.thineBar
//        view.font = UIFont.italicSystemFont(ofSize: FontSize.subTitle_16)
        view.text = "888888888888"
        return view
    }()
    
    let sectionBar: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
   
    let bottomSectionBar: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
    
    //플레이스 홀더
    let textView: UITextView = {
        let view = UITextView()
//        view.backgroundColor = .brown
        view.font = UIFont.systemFont(ofSize: FontSize.subTitle_16, weight: .light)
        view.isScrollEnabled = true
        view.textColor = Color.BaseColorWtihDark.labelColor
        return view
    }()
    
    override func configuration() {
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
        [dateLabel, sectionBar, textView, bottomSectionBar].forEach { self.addSubview($0) }
        textView.backgroundColor = .clear
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
        
        bottomSectionBar.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.height.equalTo(1)
            make.centerX.equalTo(self.snp.centerX)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(20)
        }
    }
   
    //placeholder메서드
    @discardableResult
    func setWriteVCPlaceholder(type: MorningAndNight) -> String {
        var text: String?
        
        switch type {
        case .morning:
            text = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
            
        case .night:
            text = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
        }
        
        return text!
    }
}



