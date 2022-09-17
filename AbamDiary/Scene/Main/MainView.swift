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
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .bold)
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
        //        view.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase -> 메인뷰컨에 넣어주기
        
        return view
    }()
    
    func calendarconfig() {
        calendar.placeholderType = .none
        calendar.backgroundColor =  .clear
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 20
        
        calendar.scrollDirection = .vertical
        calendar.locale = Locale(identifier: "ko-KR")
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleAlignment = .left
        calendar.appearance.headerTitleOffset = CGPoint(x: 12, y: -4)
        calendar.appearance.weekdayTextColor = Color.BaseColorWtihDark.calendarTitle
        calendar.appearance.titleWeekendColor = .systemRed
        calendar.appearance.titleDefaultColor = Color.BaseColorWtihDark.calendarTitle
        calendar.appearance.todayColor = UIColor(hex: "#9D6735")
        calendar.appearance.selectionColor = UIColor(hex: "#CAB39E")
        calendar.appearance.headerTitleColor = Color.BaseColorWtihDark.calendarTitle
        
    }
    
    //헤더로 넣는게 나을까
    let cellTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .bold)
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
        view.font = .systemFont(ofSize: 17, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.cellTtitle
        return view
    }()
    
    //여기에 이미지 받아서 넣어주기
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "고양이 1")
        //        let newWidth = UIScreen.main.bounds.width * 0.05
        //        let newimageRect = CGRect(x: 0, y: 0, width: newWidth, height: newWidth)
        //        UIGraphicsBeginImageContext(CGSize(width: <#T##Int#>, height: <#T##Int#>))
        //
        //
        //        //        view.image = UIImage(named: "morningpop") // 프로필 사진으로 바꾸기
        //        view.backgroundColor = .green
        DispatchQueue.main.async {
            
            
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = view.frame.size.height / 2
        }
        return view
    }()
    
    let profilebackgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileBackImage")
        
        return view
    }()
    
    let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(hex: "#424CAA")
        view.progressTintColor = UIColor(hex: "#FF6969")
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.height / 2
        }
        view.progress = 0.5 // 초기값
        
        return view
    }()
    
    //MARK: 이니셜라이저
    override init(frame: CGRect) {
        super.init(frame: frame)
        let date = CustomFormatter.setCellTitleDateFormatter(date: Date())
        
        calendarconfig()
        cellTitle.text = "\(date)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        [ABAMImage, cheerupUnderView, cheerupMessage, calendar, cellTitle, tableView, gageTitle, progressBar, profilebackgroundView, profileImage].forEach { self.addSubview($0) }
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
        
    }
    
    override func setConstraints() {
        ABAMImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
         
            make.leading.equalTo(calendar.snp.leading).inset(4)
            make.width.equalTo(self.snp.width).multipliedBy(0.1)
            make.height.equalTo(ABAMImage.snp.width).multipliedBy(0.85)
        }
        
        cheerupUnderView.snp.makeConstraints { make in
            make.centerY.equalTo(ABAMImage.snp.centerY)
            make.leading.equalTo(ABAMImage.snp.trailing).offset(14)
            make.verticalEdges.equalTo(cheerupMessage.snp.verticalEdges).inset(-12)
            make.trailing.equalTo(calendar.snp.trailing).inset(8)
        }
        
        cheerupMessage.snp.makeConstraints { make in
            make.centerY.equalTo(cheerupUnderView.snp.centerY)
            make.horizontalEdges.equalTo(cheerupUnderView.snp.horizontalEdges).inset(12)
        }
        
        //MARK: 캘린더 디바이스 크기 대응 분기처리
        calendar.snp.makeConstraints { make in
//            let widthRatio: Double = UIScreen.main.isWiderThan375pt ? 0.84 : 0.8
            
            make.top.equalTo(ABAMImage.snp.bottom).offset(16)
            make.bottom.equalTo(cellTitle.snp.top).offset(-12)
            make.centerX.equalTo(self.snp.centerX)
//            make.width.greaterThanOrEqualTo(UIScreen.main.bounds.width * 0.8)
//            make.height.equalTo(calendar.snp.width).multipliedBy(0.7)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).offset(-8)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.greaterThanOrEqualTo(gageTitle.snp.top).offset(-12)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(24)
            make.height.equalTo(self.snp.height).dividedBy(4.32)
        }
        
        gageTitle.snp.makeConstraints { make in
//            let topSpacing = UIScreen.main.isWiderThan375pt ? 0 : -4
            
            make.bottom.equalTo(progressBar.snp.top).offset(-24)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        progressBar.snp.makeConstraints { make in

            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(32)
            make.height.equalTo(self.snp.height).multipliedBy(0.028)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width).multipliedBy(0.12)
            
            make.width.equalTo(profileImage.snp.height).multipliedBy(1)
            make.centerY.equalTo(progressBar.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        profilebackgroundView.snp.makeConstraints { make in
            make.size.equalTo(profileImage.snp.size).multipliedBy(1.14)
            make.top.equalTo(profileImage.snp.top).offset(-6)
            make.trailing.equalTo(profileImage.snp.trailing).offset(6)
            
            
        }
    }
}

//MARK: 이미지 리사이즈
extension UIImage {
    func resize(newWidthRato: CGFloat) -> UIImage {
        let newWidth = UIScreen.main.bounds.width * newWidthRato
        
        let size = CGSize(width: newWidth, height: newWidth)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        //         printDataSize(renderImage)
        return renderImage
    }
}
