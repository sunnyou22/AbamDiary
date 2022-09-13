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
}
