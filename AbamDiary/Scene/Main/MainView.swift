//
//  MainView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import FSCalendar
import SnapKit
import MarqueeLabel

class MainView: BaseView {
    
    let ABAMImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ABAM")
        return view
    }()
    
    let cheerupUnderView: UIView = {
        let view = UILabel()
        view.backgroundColor = Color.BaseColorWtihDark.cheerupUnderView
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    let cheerupMessage: MarqueeLabel = {
        let view = MarqueeLabel()
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.cheerupMessege
        return view
    }()
    
    let coverCheerupMessageButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    let calendar: FSCalendar = {
        let view = FSCalendar()
        let test = FSCalendarCell()
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
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.headerTitleAlignment = .left
        calendar.appearance.headerTitleOffset = CGPoint(x: 12, y: -4)
        calendar.appearance.weekdayTextColor = Color.BaseColorWtihDark.calendarTitle
        calendar.appearance.titleWeekendColor = .systemRed
        calendar.appearance.titleDefaultColor = Color.BaseColorWtihDark.calendarTitle
        calendar.appearance.todayColor = Color.BaseColorWtihDark.calendarToday
        calendar.appearance.selectionColor = Color.BaseColorWtihDark.calendarSelectedDay
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
        view.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
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
        view.image = UIImage(systemName: "person")
        view.backgroundColor = Color.BaseColorWtihDark.setABAMBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(hex: "#424CAA")
        view.progressTintColor = Color.BaseColorWtihDark.progressBarPoint
        view.clipsToBounds = true
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
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
        [ABAMImage, cheerupUnderView, cheerupMessage, coverCheerupMessageButton, calendar, cellTitle, tableView, gageTitle, progressBar, profileImage].forEach { self.addSubview($0) }
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
            make.verticalEdges.equalTo(cheerupMessage.snp.verticalEdges).inset(-10)
            make.trailing.equalTo(calendar.snp.trailing).inset(8)
        }
        
        cheerupMessage.snp.makeConstraints { make in
            make.centerY.equalTo(cheerupUnderView.snp.centerY)
            make.horizontalEdges.equalTo(cheerupUnderView.snp.horizontalEdges).inset(12)
        }
        
        coverCheerupMessageButton.snp.makeConstraints { make in
            make.edges.equalTo(cheerupUnderView.snp.edges)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(ABAMImage.snp.bottom).offset(16)
            make.bottom.equalTo(cellTitle.snp.top).offset(-12)
            make.centerX.equalTo(self.snp.centerX)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).offset(-8)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.greaterThanOrEqualTo(gageTitle.snp.top).offset(-8)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(24)
            make.height.equalTo(self.snp.height).dividedBy(4.6)
        }
        
        gageTitle.snp.makeConstraints { make in
            make.bottom.equalTo(progressBar.snp.top).offset(-24)
            make.leading.equalTo(self.snp.leading).offset(28)
        }
        
        progressBar.snp.makeConstraints { make in

            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(36)
            make.height.equalTo(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-28)
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(profileImage.snp.height).multipliedBy(1)
            make.centerY.equalTo(progressBar.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}

//MARK: 이미지 리사이즈
extension UIImage {
    func resize(newWidthRato: CGFloat) -> UIImage {
        let newWidth = UIScreen.main.bounds.width * newWidthRato
        
        let size = CGSize(width: newWidth, height: newWidth * 0.88)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}
