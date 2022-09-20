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

class CalendarViewController: BaseViewController {
    
    let mainview = MainView()
    
    var changeMorningcount: Float = 0 // 테스트용
    var changeNightcount: Float = 0 // 테스트용
    var progress: Float = 0 // 변수로 빼줘야 동작
    let digit: Float = pow(10, 2) // 10의 2제곱
    var cell: CalendarTableViewCell? // 셀 인스턴스 통일시켜줘야 플레이스홀더 오류 없어짐
    var preparedCell: CalendarTableViewCell?
    
    var tasks: Results<Diary>! {
        didSet {
            mainview.tableView.reloadData()
            mainview.calendar.reloadData()
            print("리로드♻️")
        }
    }
    
    var dateFilterTask: Diary? // 캘린더에 해당하는 날짜를 받아오기 위함
    
    //MARK: - LoadView
    override func loadView() {
        self.view = mainview
    }
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 나중에 함수로 빼기
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
        let testplusM = UIBarButtonItem(title: "아침더하기", style: .plain, target: self, action: #selector(testPlusM))
        let testplusN = UIBarButtonItem(title: "밤더하기", style: .plain, target: self, action: #selector(testPlusN))
        navigationItem.rightBarButtonItems = [testplusM, testplusN]
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        mainview.calendar.dataSource = self
        mainview.calendar.delegate = self
        
        
        //        //MARK: 변하는 값에 대한 관찰시작
        //        dateModel.morningDiaryCount.bind { count in
        //            self.changeMorningcount = count
        //        }
        //
        //        dateModel.nightDiaryCount.bind { count in
        //            self.changeNightcount = count
        //        }
        //
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm() // 램 패치
        mainview.profileImage.image = loadImageFromDocument(fileName: "profile.jpg")
        print("Realm is located at:", OneDayDiaryRepository.shared.localRealm.configuration.fileURL!)
        
    }
    
    func fetchRealm() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
        testfilterDate()
        
        print("====>🟢 패치완료")
    }
    
    /*
     선택된 날짜가 없음 -> 캘린더가 오늘 날짜를 기본을 선택상태로 두지 않음
     
     1. 선택된 날짜가 없음 -> 오늘꺼 보여주기
     - 선택상태가 nil이고 캘린더 상의 오늘날짜와 생성날짜가 같은걸 뱉어주기
     2. 선택된 날짜가 있는데 오늘인 경우
     - 오늘 작성한 일기가 여러개인경우
     - 오늘 작성한 일기와 선택된 날짜가 같은 경우로 뱉어주기
     3. 선택된 날짜가 있는데 오늘이 아닌경우
     - 선택된 날짜에 작성된 일기가 여러개인경우
     - 선택된날짜와 생성된 날짜가 같은경 뱉여주기
     */
    
    func testfilterDate() {
        
        let selectedDate = CustomFormatter.setDateFormatter(date: mainview.calendar.selectedDate ?? Date())
        let calendarToday = CustomFormatter.setDateFormatter(date: mainview.calendar.today!)
        let today =  CustomFormatter.setDateFormatter(date: Date())
        var filterdateArr: LazyFilterSequence<Results<Diary>>?
        
        print("=======>날짜가선택됐습니까? ", mainview.calendar.selectedDate)
        print("캘린더 오늘 날짜", calendarToday)
        print("걍 오늘 날짜", today)
        //self.dateFilterTask = OneDayDiaryRepository.shared.fetchDate(date: Date())[0] -> 왜 이렇게 하면안됨? 오늘 작성한게 많을수도 있잖아
        
        if mainview.calendar.selectedDate == nil, calendarToday == today  {
            filterdateArr = tasks.filter({ task in
                CustomFormatter.setDateFormatter(date: task.selecteddate!) == calendarToday
            })
            self.dateFilterTask = filterdateArr?.first
        } else if mainview.calendar.selectedDate != nil, selectedDate == today {
            filterdateArr = tasks.filter({ task in
                CustomFormatter.setDateFormatter(date: task.selecteddate!) == calendarToday
            })
            self.dateFilterTask = filterdateArr?.first
            //  mainview.calendar.selectedDate != nil, calendarToday != today 와 둘다 nil일 때의 처리를 담고 있음
            // 둘다 nil면 아래에서 플레이스 홀더가 나오도록 분기처리해줌
        } else if mainview.calendar.selectedDate != nil, selectedDate != today {
            filterdateArr = tasks.filter({ task in
                CustomFormatter.setDateFormatter(date: task.selecteddate!) == selectedDate
            })
            self.dateFilterTask = filterdateArr?.first
        } else {
            self.dateFilterTask = nil
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
        //        let date =
        let labelBool = dateFilterTask?.morning != nil && dateFilterTask?.createdDate == Date()
        //
        //        if dateFilterTask?.createdDate == nil {
        //
        //        } else {
        //
        //        }
        
        // 이거 디버그 찍기
        
        let today = CustomFormatter.setDateFormatter(date: Date())
        let calendarToday = CustomFormatter.setDateFormatter(date: mainview.calendar.today ?? Date())
        let creatDate = CustomFormatter.setDateFormatter(date: dateFilterTask?.selecteddate ?? Date())
        let selecedDate = CustomFormatter.setDateFormatter(date: mainview.calendar.selectedDate ?? Date())
        
        print(dateFilterTask?.selecteddate)
        print(mainview.calendar.selectedDate)
        print(dateFilterTask?.morning)
        //    print(CustomFormatter.setDateFormatter(date: dateFilterTask!.createdDate) == selecedDate)
        print(dateFilterTask?.morning != nil && (creatDate == selecedDate))
        
        if mainview.calendar.selectedDate != nil {
            if indexPath.row == 0 {
                
                cell.diaryLabel.text = dateFilterTask?.morning != nil && (creatDate == selecedDate) ? dateFilterTask?.morning : placeholder[0]
                cell.dateLabel.text = dateFilterTask?.morningTime != nil && (creatDate == selecedDate) ? CustomFormatter.setTime(date: (dateFilterTask?.morningTime)!) : "--:--"
            } else if indexPath.row == 1 {
                cell.diaryLabel.text = self.dateFilterTask?.night != nil && (creatDate == selecedDate) ? dateFilterTask?.night : placeholder[1]
                cell.dateLabel.text = dateFilterTask?.nightTime != nil && (creatDate == selecedDate) ? CustomFormatter.setTime(date: (dateFilterTask?.nightTime)!) : "--:--"
            }
        } else {
            
            if indexPath.row == 0 {
                cell.diaryLabel.text = dateFilterTask?.morning != nil && (calendarToday == today) ? dateFilterTask?.morning : placeholder[0]
                cell.dateLabel.text = dateFilterTask?.morningTime != nil && (calendarToday == today) ? CustomFormatter.setTime(date: (dateFilterTask?.morningTime)!) : "--:--"
            } else if indexPath.row == 1 {
                cell.diaryLabel.text = self.dateFilterTask?.night != nil && (calendarToday == today) ? dateFilterTask?.night : placeholder[1]
                cell.dateLabel.text = dateFilterTask?.nightTime != nil && (calendarToday == today) ? CustomFormatter.setTime(date: (dateFilterTask?.nightTime)!) : "--:--"
            }
        }
        
        
        
        cell.setMornigAndNightConfig(index: indexPath.row)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //데이터의 일기종류가 nil 인지에 따라 화면나누기
        
        //self를 쓰는것만으로도 캡쳐됨
        //클로저에서는 그냥 [weak self]
        //deinit() 뷰디드디스어피에서 이후에 호출되는지 확인
        
        
        if indexPath.row == 0 {
            dateFilterTask?.morning != nil ? setWritModeAndTransition(.modified, diaryType: .morning, task: dateFilterTask) : setWritModeAndTransition(.newDiary, diaryType: .morning, task: dateFilterTask)
        } else {
            dateFilterTask?.night != nil ? setWritModeAndTransition(.modified, diaryType: .night, task: dateFilterTask) : setWritModeAndTransition(.newDiary, diaryType: .night, task: dateFilterTask)
        }
        
    }
    
    //cell을 통일시켜주기
    func fetchCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> CalendarTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return CalendarTableViewCell()}
        self.cell = cell
        
        return cell
    }
    
    func setPreparedCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> CalendarTableViewCell {
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return CalendarTableViewCell()}
        
        cell2.dateLabel.text = CustomFormatter.setTime(date: Date())
        self.preparedCell = cell
        
        return cell2
    }
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: Diary?) {
        let vc = WriteViewController(diarytype: diaryType, writeMode: mode)
        vc.data = task
        vc.fetch = fetchRealm
        vc.selectedDate = mainview.calendar.selectedDate ?? Date()
        //task nil 로 분기해보기
        
        switch mode {
            
        case .newDiary:
            print("====>🚀 작성화면으로 가기")
            transition(vc, transitionStyle: .push)
            switch diaryType {
            case .morning:
                vc.navigationItem.title = "아침일기"
                vc.writeView.setWriteVCPlaceholder(type: .morning)
                
            case .night:
                vc.navigationItem.title = "저녁일기"
                vc.writeView.setWriteVCPlaceholder(type: .night)
                
            }
        case .modified:
            print("====>🚀 수정화면으로 가기")
            transition(vc, transitionStyle: .push)
            vc.navigationItem.title = "수정"
            
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
        testfilterDate()
        mainview.tableView.reloadData()
        mainview.cellTitle.text = CustomFormatter.setCellTitleDateFormatter(date: date)
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let test = CustomFormatter.setCellTitleDateFormatter(date: date)
        let testArr = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        } // 해당 날짜에 포함되는 데이터들을 뽑아옵
        
        print(testArr)
        
        for task in testArr {
            if task.morning != nil && task.night != nil {
                return 2
            } else if task.morning == nil && task.night == nil {
                return 0
            } else {
                return 1
            }
            
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        let test = CustomFormatter.setCellTitleDateFormatter(date: date)
        let testArr = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        } // 해당 날짜에 포함되는 데이터들을 뽑아옵
        print(testArr)
        
        for task in testArr {
            if task.morning != nil && task.night != nil {
                return [UIColor.systemRed, UIColor.systemBlue]
            } else if task.morning == nil && task.night == nil {
                return nil
            } else if task.morning != nil && task.night == nil {
                return [UIColor.systemRed]
            } else if task.morning == nil && task.night != nil {
                return [UIColor.systemBlue]
            }
        }
        return nil
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        
        let test = CustomFormatter.setCellTitleDateFormatter(date: date)
        let testArr = tasks.filter { task in
            CustomFormatter.setCellTitleDateFormatter(date: task.selecteddate ?? Date()) == test
        } // 해당 날짜에 포함되는 데이터들을 뽑아옵
        print(testArr)
        
        for task in testArr {
            if task.morning != nil && task.night != nil {
                return [UIColor.systemRed, UIColor.systemBlue]
            } else if task.morning == nil && task.night == nil {
                return nil
            } else if task.morning != nil && task.night == nil {
                return [UIColor.systemRed]
            } else if task.morning == nil && task.night != nil {
                return [UIColor.systemBlue]
            }
        }
        return nil
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
    
    @objc func testPlusM() {
        self.changeMorningcount += 20.0
        let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeMorningcount + self.changeNightcount)) * digit) / digit)
        
        if moringCountRatio.isNaN {
            progress = 0
        } else {
            progress = moringCountRatio
            print(progress)
        }
        print("================", progress)
        //        dateModel.morningDiaryCount.value = changeMorningcount
        mainview.progressBar.setProgress(progress, animated: true)
        animationUIImage()
    }
    
    @objc func testPlusN() {
        
        self.changeNightcount += 20.0
        let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeMorningcount + self.changeNightcount)) * digit) / digit)
        
        if moringCountRatio.isNaN {
            progress = 0
        } else {
            progress = moringCountRatio
            print(progress)
        }
        print("================", progress)
        //        dateModel.nightDiaryCount.value = changeNightcount
        
        mainview.progressBar.setProgress(progress, animated: true)
        animationUIImage()
    }
    
    
    
    //MARK: 이미지 애니메이션
    func animationUIImage() {
        UIImageView.animate(withDuration: 1) {
            let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeNightcount + self.changeMorningcount)) * self.digit) / self.digit)
            
            let width = Float(self.mainview.progressBar.frame.size.width) * moringCountRatio - (Float(self.mainview.progressBar.frame.size.width) / 2)
            //
            
            print(self.mainview.progressBar.frame.size.width)
            
            self.mainview.progressBar.transform = .identity
            
            let newWidth = (round(width) * self.digit) / self.digit
            
            if moringCountRatio < 0.5 {
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profilebackgroundView.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                print("🔥 0.5이하", moringCountRatio)
                print("🟢 0.5이하", width)
                print("👉 new 0.5이하", newWidth)
                
            } else if moringCountRatio > 0.5 {
                print("🔥 0.5이상", moringCountRatio)
                print("🟢 0.5이상", width)
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profilebackgroundView.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else {
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profileImage.transform = .identity
            }
            
            
        } completion: { _ in
            let moringCountRatio: Float = (round((self.changeMorningcount / (self.changeMorningcount + self.changeNightcount)) * self.digit) / self.digit)
            let width: Float = Float(self.mainview.progressBar.frame.size.width) * moringCountRatio - (Float(self.mainview.progressBar.frame.size.width) / 2)
            let newWidth = (round(width) * self.digit) / self.digit
            
            
            if moringCountRatio < 0.5 {
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profilebackgroundView.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else if moringCountRatio > 0.5 {
                
                self.mainview.profileImage.transform = .identity
                self.mainview.profileImage.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profilebackgroundView.transform = CGAffineTransform(translationX: CGFloat(newWidth), y: 0)
            } else {
                self.mainview.profilebackgroundView.transform = .identity
                self.mainview.profileImage.transform = .identity
            }
        }
        
    }
}
