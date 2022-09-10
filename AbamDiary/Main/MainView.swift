//
//  MainView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import FSCalendar
import SnapKit

class MainView: BaseView {
    
    let ABAMImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "ABAM")
       return view
    }()
    
    let cheerupMessage: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .semibold)
        view.textColor = Color.BaseColorWtihDark.cheerupMessege
        view.text = "응원의 메세지를 추가해보세요!"
        return view
    }()
    
    let calendar: FSCalendar = {
        let view = FSCalendar()
        view.placeholderType = .none
        return view
    }()
     
    let cellTitle: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.largeTitle_20, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    let gageTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.largeTitle_20, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    override func configuration() {
        [ABAMImage, cheerupMessage, calendar].forEach { self.addSubview($0) }
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
//       self.addSubview(calendar)
    }
    
    override func setConstraints() {
        ABAMImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(28)
            make.leading.equalTo(self.snp.leading).offset(28)
            make.width.equalTo(UIScreen.main.bounds.width * 0.09)
            make.height.equalTo(ABAMImage.snp.width).multipliedBy(0.78)
        }
        
        cheerupMessage.snp.makeConstraints { make in
            make.centerY.equalTo(ABAMImage.snp.centerY)
            make.leading.equalTo(ABAMImage.snp.trailing).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(ABAMImage.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(28)
            make.trailing.equalTo(self.snp.trailing).offset(-28)
            make.height.equalTo(calendar.snp.width).multipliedBy(1)
        }
    }
}
