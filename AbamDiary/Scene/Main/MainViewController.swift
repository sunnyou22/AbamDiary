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
    //MARK: observable 변경하기
    
    var changeMorningcount: Float = 0 // 테스트용
    var changeNightcount: Float = 0 // 테스트용
    var progress: Float = 0 // 변수로 빼줘야 동작
    let digit: Float = pow(10, 2) // 10의 2제곱
    var cell: MainTableViewCell? // 셀 인스턴스 통일시켜줘야 플레이스홀더 오류 없어짐
    var preparedCell: MainTableViewCell?
    
    var tasks: Results<Diary>! {
        didSet {
            mainview.tableView.reloadData()
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
     
        
        print("Realm is located at:", OneDayDiaryRepository.shared.localRealm.configuration.fileURL!)
        
    }
    
    func fetchRealm() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
        testfilterDate()
        
        print("====>🟢 패치완료")
    }
    
    func testfilterDate() {
        
        //        switch mainview.calendar.selectedDate {
        //        case mainview.calendar.today:
        //            dateFilterTask = OneDayDiaryRepository.shared.fetchDate(date: Date()).first
        //        default :
        let selectedDate = CustomFormatter.setDateFormatter(date: mainview.calendar.selectedDate ?? Date())
        let today = CustomFormatter.setDateFormatter(date: Date())
        var filterdateArr: LazyFilterSequence<Results<Diary>>?
        
        
        
        if mainview.calendar.selectedDate == nil {
            filterdateArr = tasks.filter { task in
                CustomFormatter.setDateFormatter(date: self.mainview.calendar.today!) == today
            }
            self.dateFilterTask = filterdateArr?.first
        } else {
            filterdateArr = tasks.filter { task in
                CustomFormatter.setDateFormatter(date: task.selecteddate!) == selectedDate
            }
            self.dateFilterTask = filterdateArr?.first
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
    func fetchCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> MainTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return MainTableViewCell()}
        self.cell = cell
        
        return cell
    }
    
    func setPreparedCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> MainTableViewCell {
        guard let cell2 = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return MainTableViewCell()}
        
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
extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        testfilterDate()
        mainview.tableView.reloadData()
        mainview.cellTitle.text = CustomFormatter.setCellTitleDateFormatter(date: date)
        
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
