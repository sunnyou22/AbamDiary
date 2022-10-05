//
//  MainViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//



import UIKit

import FSCalendar
import SnapKit
import RealmSwift
import MarqueeLabel

class CalendarViewController: BaseViewController {
    
    let mainview = MainView()
    static var gageCountModel = GageModel()
    var changeMorningcount: Float = 0 // 테스트용
    var changeNightcount: Float = 0 // 테스트용
    var progress: Float = 0 // 변수로 빼줘야 동작
    let digit: Float = pow(10, 2) // 10의 2제곱
    var cell: CalendarTableViewCell? // 셀 인스턴스 통일시켜줘야 플레이스홀더 오류 없어짐
    var preparedCell: CalendarTableViewCell?
    
    var tasks: Results<Diary>! {
        didSet {
            mainview.tableView.reloadData()
            DispatchQueue.main.async {
                self.mainview.calendar.reloadData()
            }
            print("Realm is located at:", OneDayDiaryRepository.shared.localRealm.configuration.fileURL!)
                         print("리로드캘린더♻️")
        }
    }
    
    var monthFilterTasks: Results<Diary>!
    var moningTask: Diary?
    var nightTask: Diary? // 캘린더에 해당하는 날짜를 받아오기 위함
    var diaryList: [Diary?]?
    var isExpanded = false
    
    //MARK: - LoadView
    override func loadView() {
        self.view = mainview
    }
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        
        mainview.calendar.dataSource = self
        mainview.calendar.delegate = self
        //MARK: 변하는 값에 대한 관찰시작
        CalendarViewController.gageCountModel.morningDiaryCount.bind { count in
            self.changeMorningcount = count
        }
        
        CalendarViewController.gageCountModel.nightDiaryCount.bind { count in
            self.changeNightcount = count
        }
        setNavigation()
        
        mainview.cheerupMessage.speed = .duration(36)
        mainview.coverCheerupMessageButton.addTarget(self, action: #selector(pauseRestart), for: .touchUpInside)
    }
    
    func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
      
    navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func pauseRestart(_ sender: UIButton) {
        isExpanded = !isExpanded
        
        if isExpanded {
           mainview.cheerupMessage.pauseLabel()
        } else {
            mainview.cheerupMessage.unpauseLabel()
        }
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "=============================")
        mainview.profileImage.image = loadImageFromDocument(fileName: "profile.jpg")
       
        fetchRealm() // 램 패치
     
        //카운트 세팅
        calculateMoringDiary()
        calculateNightDiary()
        animationUIImage()
        
        guard changeMorningcount != 0.0 || changeNightcount != 0.0 else {
            animationUIImage()
            mainview.progressBar.progress = 0.5
            return
        }
        
        //화면이 로드될 때도 호출되야하기 때문에 여기서만 걸어주기

        setProgressRetio()
        animationUIImage()
       
       //랜덤응원메세지 반영
        mainview.cheerupMessage.text = CheerupMessageRepository.shared.fetchDate(ascending: false).randomElement()?.cheerup ?? "응원의 메세지를 추가해보세요!"
       self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainview.cheerupMessage.text = CheerupMessageRepository.shared.fetchDate(ascending: false).randomElement()?.cheerup ?? "응원의 메세지를 추가해보세요!"
    }
    
    func fetchRealm() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
        diaryTypefilterDate()
        
        //시간잘 맞춰서 해당 달의 날짜가 들어옴
        monthFilterTasks = OneDayDiaryRepository.shared.fetchFilterMonth(start: CustomFormatter.isStarDateOfMonth(), last: CustomFormatter.isDateEndOfMonth())
    }
    
    //MARK: 여기서 아침일기 저녁일기 task 생성
    func diaryTypefilterDate() {
        
        let selectedDate = CustomFormatter.setDateFormatter(date: mainview.calendar.selectedDate ?? Date())
        let calendarToday = CustomFormatter.setDateFormatter(date: mainview.calendar.today!)
        let today =  CustomFormatter.setDateFormatter(date: Date())
        
        //self.dateFilterTask = OneDayDiaryRepository.shared.fetchDate(date: Date())[0] -> 왜 이렇게 하면안됨? 오늘 작성한게 많을수도 있잖아
        
        // 오늘인 캘린더를 띄워서 경우
        if mainview.calendar.selectedDate == nil, calendarToday == today  {
            moningTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.today!, type: 0).first
            nightTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.today!, type: 1).first
            // 오늘을 선택한 경우
        } else if mainview.calendar.selectedDate != nil, selectedDate == today {
            moningTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.today!, type: 0).first // nil이 들어올 수 있음
            nightTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.today!, type: 1).first
            // 오늘이 아닌 다른 날을 선택한 경우
        } else if mainview.calendar.selectedDate != nil, selectedDate != today {
            moningTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.selectedDate!, type: 0).first
            nightTask = OneDayDiaryRepository.shared.fetchDate(date: mainview.calendar.selectedDate!, type: 1).first
        } else {
            moningTask = nil
            nightTask = nil
        }
    }
}

//램 데이터 기반으로 바꾸기
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainview.tableView.frame.height / 2.1
    }
    // 타이틀적인 요소는 섹션도 좋음
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MorningAndNight.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = fetchCell(tableView, didSelectRowAt: indexPath)
        let placeholder = ["오늘 아침! 당신의 한줄은 무엇인가요?", "오늘 밤! 당신의 한줄은 무엇인가요?"]
        
        diaryList = [moningTask, nightTask]
        
        //배열의 옵셔널 풀어주기
        guard let diaryList = diaryList else {
            cell.diaryLabel.text = placeholder[indexPath.row]
            cell.dateLabel.text = "--:--"
            
            cell.setMornigAndNightConfig(index: indexPath.row)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return UITableViewCell()
        }
      // 내용 셀에 적용
        cell.diaryLabel.text = diaryList[indexPath.row]?.contents ?? placeholder[indexPath.row]
        guard let time = diaryList[indexPath.row]?.createdDate else {
            cell.dateLabel.text = "--:--"
            cell.dateLabel.textColor = Color.BaseColorWtihDark.setDiaryInCellPlacholder(type: .allCases[indexPath.row])
            cell.setMornigAndNightConfig(index: indexPath.row)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        cell.dateLabel.text = CustomFormatter.setTime(date: time)
        cell.setMornigAndNightConfig(index: indexPath.row)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            guard let moningTask = moningTask else  {
                setWritModeAndTransition(.newDiary, diaryType: .morning, task: moningTask)
                return
            }
            setWritModeAndTransition(.modified, diaryType: .morning, task: moningTask)
            
        } else {
            guard let nightTask = nightTask else  {
                setWritModeAndTransition(.newDiary, diaryType: .night, task: nightTask)
                return
            }
            setWritModeAndTransition(.modified, diaryType: .night, task: nightTask)
        }
        
    }
    
    //cell을 통일시켜주기
    func fetchCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> CalendarTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return CalendarTableViewCell()}
        self.cell = cell
        
        return cell
    }
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: Diary?) {
        let vc = WriteViewController(diarytype: diaryType, writeMode: mode)
       
        vc.data = task
        vc.selectedDate = mainview.calendar.selectedDate ?? Date()
        //task nil 로 분기해보기
        
        switch mode {
            
        case .newDiary:
            vc.hidesBottomBarWhenPushed = true
            transition(vc, transitionStyle: .push)
            switch diaryType {
            case .morning:
                vc.writeView.setWriteVCPlaceholder(type: .morning)
                
            case .night:
                vc.writeView.setWriteVCPlaceholder(type: .night)
                
            }
        case .modified:
            vc.hidesBottomBarWhenPushed = true
            transition(vc, transitionStyle: .push)
        }
        
    }
}
//MARK: - 캘린더

//MARK: 캘린더 디자인하기
extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date == Date() ? false : true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        diaryTypefilterDate()
        mainview.tableView.reloadData()
        mainview.cellTitle.text = CustomFormatter.setCellTitleDateFormatter(date: date)
        
        let lastDate = CustomFormatter.setDateFormatter(date:  CustomFormatter.isDateEndOfMonth())
        let calendarDay = CustomFormatter.setDateFormatter(date: date)
        let calendarToday = CustomFormatter.setDateFormatter(date: calendar.today!)
        
        if lastDate == calendarDay && lastDate == calendarToday {
            let vc = PopUpViewController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let test = CustomFormatter.setDateFormatter(date: date)
        let testArr = tasks.filter { task in
            CustomFormatter.setDateFormatter(date: task.selecteddate ?? Date()) == test
        }
        
        if testArr.count == 2 {
            return 2
        } else if testArr.count == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        let test = CustomFormatter.setCellTitleDateFormatter(date: date)
        //해당날짜에 맞는 걸로 필터
        let moningTask = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        }.first { $0.type == 0 }
        let nightTask = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        }.first { $0.type == 1 }
      
            if moningTask != nil && nightTask != nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .morning), Color.BaseColorWtihDark.setCalendarPoint(type: .night)]
            } else if moningTask == nil && nightTask == nil {
                return nil
            } else if moningTask != nil && nightTask == nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .morning)]
            } else if moningTask == nil && nightTask != nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .night)]
            }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let test = CustomFormatter.setCellTitleDateFormatter(date: date)
        //해당날짜에 맞는 걸로 필터
        let moningTask = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        }.first { $0.type == 0 }
        let nightTask = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        }.first { $0.type == 1 }
      
            if moningTask != nil && nightTask != nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .morning), Color.BaseColorWtihDark.setCalendarPoint(type: .night)]
            } else if moningTask == nil && nightTask == nil {
                return nil
            } else if moningTask != nil && nightTask == nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .morning)]
            } else if moningTask == nil && nightTask != nil {
                return [Color.BaseColorWtihDark.setCalendarPoint(type: .night)]
            }
        
        return nil
    }
 
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let lastDate = CustomFormatter.setDateFormatter(date:  CustomFormatter.isDateEndOfMonth())
        let calendarDay = CustomFormatter.setDateFormatter(date: date)
        let calendarToday = CustomFormatter.setDateFormatter(date: calendar.today!)
        
        if lastDate == calendarToday {
            
            switch calendarDay {
            case lastDate:
                return Color.BaseColorWtihDark.popupViewLabel(type: .morning)
            default:
                return nil
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let lastDate = CustomFormatter.setDateFormatter(date:  CustomFormatter.isDateEndOfMonth())
        let calendarDay = CustomFormatter.setDateFormatter(date: date)
        let calendarToday = CustomFormatter.setDateFormatter(date: calendar.today!)
        
        if lastDate == calendarToday {
            
            switch calendarDay {
            case lastDate:
                return Color.BaseColorWtihDark.popupViewLabel(type: .morning)
            default:
                return appearance.selectionColor
            }
        }
        return appearance.selectionColor
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 1.5
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 2)
    }
}

//MARK: 네비게이션 타이틀 뷰 커스텀
class navigationTitleVIew: BaseView {
    let title: UILabel = {
        let view = UILabel()
        view.text = "ABAM"
        view.textColor = Color.BaseColorWtihDark.navigationBarItem
        view.font = .systemFont(ofSize: FontSize.navigationTitle, weight: .heavy)
        
        return view
    }()
    
    override func configuration() {
        self.addSubview(title)
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.centerX.centerX.equalTo(self)
            make.leading.bottom.trailing.equalTo(self)
            make.top.equalTo(self.snp.top).offset(12)
        }
    }
}

//MARK: - 애니메이션 Extension => 모델로 빼주기
extension CalendarViewController {
    
    //아침일기 개수 계산
    func calculateMoringDiary() {

        let filterMorningcount = monthFilterTasks.filter { task in
            return task.type == 0
        }.count
        
        CalendarViewController.gageCountModel.morningDiaryCount.value = Float(filterMorningcount)
        self.changeMorningcount = Float(filterMorningcount)
    }
    
    //저녁일기 개수 계산
    func calculateNightDiary() {

        let filterNightcount = monthFilterTasks.filter { task in
            return task.type == 1
        }.count
                
        CalendarViewController.gageCountModel.nightDiaryCount.value = Float(filterNightcount)
        self.changeNightcount = Float(filterNightcount)
    }
    
    func setProgressRetio() {
        let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeMorningcount + self.changeNightcount)) * digit) / digit)
        
        if moringCountRatio.isNaN {
            progress = 0
        } else {
            progress = moringCountRatio
        }
        mainview.progressBar.setProgress(progress, animated: true)
    }
    
    
    //MARK: 이미지 애니메이션
    func animationUIImage() {
        
        UIImageView.animate(withDuration: 0.4) {
            let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeNightcount + self.changeMorningcount)) * self.digit) / self.digit)
            
            let width = Float(self.mainview.progressBar.frame.size.width) * moringCountRatio - (Float(self.mainview.progressBar.frame.size.width) / 2)
            
            self.mainview.progressBar.transform = .identity
            
            let newWidth = (round(width) * self.digit) / self.digit
            
            if moringCountRatio < 0.5 || moringCountRatio > 0.5 {
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                 
            } else {
                self.mainview.profileImage.transform = .identity
            }
            
            
        } completion: { _ in
            let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeMorningcount + self.changeNightcount)) * self.digit) / self.digit)
            let width: Float = Float(self.mainview.progressBar.frame.size.width) * moringCountRatio - (Float(self.mainview.progressBar.frame.size.width) / 2)
            let newWidth = (round(width) * self.digit) / self.digit
            
            
            if moringCountRatio < 0.5 {
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else if moringCountRatio > 0.5 {
                
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else {
                self.mainview.profileImage.transform = .identity
            }
        }
        
    }
}
