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
    
    let cheerupUnderView: UIView = {
        let view = UILabel()
        view.backgroundColor = UIColor(hex: "#DDE4D3")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    let cheerupMessage: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.label_13, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.cheerupMessege
        view.text = "응원의 메세지를 추가해보세요!"
        return view
    }()
    
    let calendar: FSCalendar = {
        let view = FSCalendar()
        view.placeholderType = .none
        view.backgroundColor =  .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.appearance.headerDateFormat = "YYYY년 MM월"
        view.scrollDirection = .vertical
        view.locale = Locale(identifier: "ko-KR")
        view.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .light)
        view.appearance.headerTitleAlignment = .left
        view.appearance.headerTitleOffset = CGPoint(x: 12, y: -4)
        
        return view
    }()
     
    //헤더로 넣는게 나을까
    let cellTitle: UILabel = {
       let view = UILabel()
        view.text = "한줄일기"
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.cellTtitle
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        view.separatorStyle = .none
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        view.isScrollEnabled = false
        return view
    }()
    
    let gageTitle: UILabel = {
        let view = UILabel()
        view.text = "나는 어떤 아밤이?"
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.cellTtitle
        return view
    }()
    
    override func configuration() {
        [ABAMImage, cheerupUnderView, cheerupMessage, calendar, cellTitle, tableView, gageTitle].forEach { self.addSubview($0) }
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
//       self.addSubview(calendar)
    }
    
    override func setConstraints() {
        ABAMImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(calendar.snp.leading).inset(4)
            make.width.equalTo(UIScreen.main.bounds.width * 0.09)
            make.height.equalTo(ABAMImage.snp.width).multipliedBy(0.8)
        }
        
        cheerupUnderView.snp.makeConstraints { make in
            make.centerY.equalTo(ABAMImage.snp.centerY)
            make.leading.equalTo(ABAMImage.snp.trailing).offset(14)
            make.verticalEdges.equalTo(cheerupMessage.snp.verticalEdges).inset(-8)
            make.trailing.equalTo(calendar.snp.trailing).inset(8)
        }
        
        cheerupMessage.snp.makeConstraints { make in
            make.centerY.equalTo(cheerupUnderView.snp.centerY)
            make.horizontalEdges.equalTo(cheerupUnderView.snp.horizontalEdges).inset(12)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(ABAMImage.snp.bottom).offset(16)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width *  0.84)
            make.height.equalTo(calendar.snp.width).multipliedBy(0.7)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(cellTitle.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(24)
            make.height.equalTo(UIScreen.main.bounds.height * 0.22)
        }
        
        gageTitle.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(-4)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
    }
}
