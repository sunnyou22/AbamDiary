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
        view.font = .systemFont(ofSize: FontSize.label_14, weight: .bold)
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
    
    let morningBar: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF3B30", alpha: 0.7)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
        }
        return view
    }()
    
    let nightBar: UIView = {
        let view = UIView()
         view.backgroundColor = UIColor(hex: "#4F5CCB")
         view.layer.borderColor = UIColor.black.cgColor
         view.layer.borderWidth = 2
         view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
         view.layer.masksToBounds = true
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
        }
         return view
    }()
    
    let profileImage: UIImageView = {
       let view = UIImageView()
//        view.image = UIImage(named: "morningpop") // 프로필 사진으로 바꾸기
        view.backgroundColor = .green
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.size.height / 2
        }
        return view
    }()
    
    //MARK: 이니셜라이저
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        [ABAMImage, cheerupUnderView, cheerupMessage, calendar, cellTitle, tableView, gageTitle, morningBar, nightBar, profileImage].forEach { self.addSubview($0) }
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
//       self.addSubview(calendar)
    }
    
    override func setConstraints() {
        ABAMImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(calendar.snp.leading).inset(4)
            make.width.equalTo(UIScreen.main.bounds.width * 0.09)
            make.height.equalTo(ABAMImage.snp.width).multipliedBy(0.85)
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
        
        morningBar.snp.makeConstraints { make in
            make.top.equalTo(gageTitle.snp.bottom).offset(28)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.height.equalTo(UIScreen.main.bounds.height * 0.022)
            make.width.equalTo((UIScreen.main.bounds.width - 48) / 2) // 모닝바를 위주로 움직이기
        }
        
        nightBar.snp.makeConstraints { make in
            make.top.equalTo(gageTitle.snp.bottom).offset(28)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
            make.height.equalTo(UIScreen.main.bounds.height * 0.022)
            make.leading.equalTo(morningBar.snp.trailing) // 모닝바에 의존
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.06)
            make.width.equalTo(profileImage.snp.height).multipliedBy(1)
            make.centerY.equalTo(morningBar.snp.centerY)
            make.trailing.equalTo(morningBar.snp.trailing)
//            make.trailing.equalTo(morningBar.snp.trailing).offset((UIScreen.main.bounds.height * 0.065) / 2) // frame으로 구하기
        }
    }
}
