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
import FirebaseAnalytics

class CalendarViewController: BaseViewController {
    
    let mainview = MainView()
    var calendarModel = CalendarModel()
    var cell: CalendarTableViewCell? // 셀 인스턴스 통일시켜줘야 플레이스홀더 오류 없어짐
    var preparedCell: CalendarTableViewCell?
    var isExpanded: Bool?
    
    //    var monthFilterTasks: Results<Diary>!
    //    var moningTask: Diary?
    //    var nightTask: Diary? // 캘린더에 해당하는 날짜를 받아오기 위함

    //    var isExpanded = false
    
    //MARK: bindData
        func bindData() {
            
            calendarModel.tasks.bind { [weak self] value in
                self?.mainview.tableView.reloadData()
                DispatchQueue.main.async {
                    self?.mainview.calendar.reloadData()
                }
                print("Realm is located at:", OneDayDiaryRepository.shared.localRealm.configuration.fileURL!)
                print("리로드캘린더♻️")

            }
            
            //데이터 fetch
            calendarModel.fetchRealm()
            
            //한달 일기 아침task count 구하기
            calendarModel.monthFilterTasks.bind { [weak self] list in
                guard let list = list else {
                    return
                }
              
                self?.calendarModel.filterMorningcount.value = list.filter { task in
                        return task.type == 0
                    }.count
               
                self?.calendarModel.filterNightcount.value = list.filter { task in
                        return task.type == 1
                    }.count
            }
         }
    
    //MARK: - LoadView
    override func loadView() {
        self.view = mainview
    }
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettiongViewController.requestAutorization()
        
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        
        mainview.calendar.dataSource = self
        mainview.calendar.delegate = self
        
        //        bindData()
        
        setNavigation()
        
        mainview.cheerupMessage.speed = .duration(36)
        mainview.coverCheerupMessageButton.addTarget(self, action: #selector(pauseRestart), for: .touchUpInside)
        
        UserDefaultHelper.shared.initialUser = true
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let navigationtitleView = NavigationTitleVIew()
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape", withConfiguration: config), style: .plain, target: self, action: #selector(gosettingVC))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
        navigationItem.rightBarButtonItem = settingButton
        
        self.navigationController?.navigationBar.tintColor = Color.BaseColorWtihDark.navigationBarItem
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.BaseColorWtihDark.navigationBarItem]
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func gosettingVC() {
        let vc = SettiongViewController()
        transition(vc, transitionStyle: .push)
    }
    
    @objc private func pauseRestart(_ sender: UIButton) {
        calendarModel.isExpanded.bind { [weak self] value in
            guard var isExpanded = self?.isExpanded else { return }
            
            isExpanded = !value
            
            if isExpanded {
                self?.mainview.cheerupMessage.pauseLabel()
            } else {
                self?.mainview.cheerupMessage.unpauseLabel()
            }
        }
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "=============================")
    
        mainview.profileImage.image = CustomFileManager.shared.loadImageFromDocument(fileName: "profile.jpg")
     
        bindData()
        
        //애니메이션
        calendarModel.checkCount {
            DispatchQueue.main.async { [weak self] in
                self?.animationUIImage()
            }
            mainview.progressBar.progress = 0.5
        } nonzero: {
            print("nonzero========================")
            DispatchQueue.main.async { [weak self] in
                self?.animationUIImage()
            }
            calendarModel.setProgressRetio { [weak self] progress in
                self?.mainview.progressBar.setProgress(progress, animated: true)
            }
        }
        
        //랜덤응원메세지 반영
        mainview.cheerupMessage.text = CheerupMessageRepository.shared.fetchDate(ascending: false).randomElement()?.cheerup ?? "응원의 메세지를 추가해보세요!"
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainview.cheerupMessage.text = CheerupMessageRepository.shared.fetchDate(ascending: false).randomElement()?.cheerup ?? "응원의 메세지를 추가해보세요!"
    }
}
 

//램 데이터 기반으로 바꾸기
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 고정값이면 rowheight으로 바꾸기
        return mainview.tableView.frame.height / 2.1
    }
    // 타이틀적인 요소는 섹션도 좋음
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MorningAndNight.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = fetchCell(tableView, didSelectRowAt: indexPath)
        let placeholder = ["오늘 아침! 당신의 한줄은 무엇인가요?", "오늘 밤! 당신의 한줄은 무엇인가요?"]
        
        calendarModel.diaryList.value = [calendarModel.moningTask.value, calendarModel.nightTask.value]
        
        //배열의 옵셔널 풀어주기
        guard let diaryList = calendarModel.diaryList.value else {
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
            guard let moningTask = calendarModel.moningTask.value else  {
            setWritModeAndTransition(.newDiary, diaryType: .morning, task: calendarModel.moningTask.value)
                return
            }
            setWritModeAndTransition(.modified, diaryType: .morning, task: moningTask)
            
        } else {
            guard let nightTask = calendarModel.nightTask.value else  {
                setWritModeAndTransition(.newDiary, diaryType: .night, task: calendarModel.nightTask.value)
                return
            }
            setWritModeAndTransition(.modified, diaryType: .night, task: nightTask)
        }
        
    }
    
    //cell을 통일시켜주기
    private func fetchCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> CalendarTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return CalendarTableViewCell()}
        self.cell = cell
        
        return cell
    }
    
    private func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: Diary?) {
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
        calendarModel.diaryTypefilterDate()
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
        
        guard let tasks = calendarModel.tasks.value else {
            print(#function ,"tasks가 없습니다.")
            return 0
        }
        
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
        
        guard let tasks = calendarModel.tasks.value else {
            print(#function ,"tasks가 없습니다.")
            return nil
        }
        
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
        
        guard let tasks = calendarModel.tasks.value else {
            print(#function ,"tasks가 없습니다.")
            return nil
        }
        
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
        let eventScaleFactor: CGFloat = 1.2
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
}

//MARK: 네비게이션 타이틀 뷰 커스텀
class NavigationTitleVIew: BaseView {
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
    
    //MARK: 이미지 애니메이션
    private func animationUIImage() {
        let digit: Float = pow(10, 2)
        let moringCountRatio = calendarModel.moringCountRatio()
        let width = Float(self.mainview.progressBar.frame.size.width) * moringCountRatio - (Float(self.mainview.progressBar.frame.size.width) / 2)
        let newWidth = (round(width) * digit) / digit
        
        print(moringCountRatio, width, newWidth, "=============😽")
        
        UIImageView.animate(withDuration: 0.4) {
            
            self.mainview.progressBar.transform = .identity
            
            if moringCountRatio < 0.5 || moringCountRatio > 0.5 {
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                
            } else {
                self.mainview.profileImage.transform = .identity
            }
        } completion: { [weak self] _ in
            
            if moringCountRatio < 0.5 {
                self?.mainview.profileImage.transform = .identity
                self?.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else if moringCountRatio > 0.5 {
                print(moringCountRatio, width, newWidth, "=============😽📍📍")
                self?.mainview.profileImage.transform = .identity
                self?.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else {
                self?.mainview.profileImage.transform = .identity
            }
        }
    }
}
