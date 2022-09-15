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

class MainViewController: BaseViewController {
    
    let mainview = MainView()
    //MARK: observable 변경하기
    var viewModel = GageModel()
    var changeMorningcount: Float = 0 // 테스트용
    var changeNightcount: Float = 0 // 테스트용
    var progress: Float = 0 // 변수로 빼줘야 동작
    let digit: Float = pow(10, 2) // 10의 2제곱
    var cell: MainTableViewCell? // 셀 인스턴스 통일시켜줘야 플레이스홀더 오류 없어짐
    var preparedCell: MainTableViewCell?
    var testCelllist: [String] = []
    
    var tasks: Results<MainList>! {
        didSet {
            testCelllist.removeAll()
            mainview.tableView.reloadData()
            print("♻️")
        }
    }
    
    var dateFilterTask: MainList? // 캘린더에 해당하는 날짜를 받아오기 위함
    
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
        
        //MARK: 변하는 값에 대한 관찰시작
        viewModel.morningDiaryCount.bind { count in
            self.changeMorningcount = count
        }
        
        viewModel.nightDiaryCount.bind { count in
            self.changeNightcount = count
        }
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm() // 램 패치
        print("Realm is located at:", MainListRepository.shared.localRealm.configuration.fileURL!)
    }
    
   
    
    
    func fetchRealm() {
        tasks = MainListRepository.shared.fetchLatestOrder()
        testfilterDate()
        
        print("====>🟢 패치완료")
    }
    
    func testfilterDate() {
        let selectedDate = CustomFormatter.setDateFormatter(date: mainview.calendar.selectedDate ?? Date())
        let filterdateArr = tasks.filter { task in
            CustomFormatter.setDateFormatter(date: task.date) == selectedDate
        }
        dateFilterTask = filterdateArr.first
    }
}



//램 데이터 기반으로 바꾸기
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainview.tableView.frame.height / 2.2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MorningAndNight.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fetchCell(tableView, didSelectRowAt: indexPath)
        let placeholder = ["오늘 아침! 당신의 한줄은 무엇인가요?", "오늘 밤! 당신의 한줄은 무엇인가요?"]
        
        
        //fscalendar로 뺄까
        
        //        if dateFilterTask != nil {
        //            if indexPath.row == 0 {
        //                cell.diaryLabel.text = dateFilterTask?.mornimgDiary
        //            } else {
        //                cell.diaryLabel.text = dateFilterTask?.nightDiary
        //            }
        //        } else {
        //            cell.diaryLabel.text = cell.setMainCellPlaceholder(type: .allCases[indexPath.row])
        //        }
        
   
            if indexPath.row == 0  {
                cell.diaryLabel.text = dateFilterTask?.mornimgDiary != nil ? dateFilterTask?.mornimgDiary : "오늘 아침! 당신의 한줄은 무엇인가요?"
            } else if indexPath.row == 1 {
                cell.diaryLabel.text = self.dateFilterTask?.nightDiary != nil ? dateFilterTask?.nightDiary : "오늘 밤! 당신의 한줄은 무엇인가요?"
            }
        
//
        print(#function, cell.diaryLabel.text)
        testCelllist.append(cell.diaryLabel.text ?? placeholder[indexPath.row])
        
        cell.setMornigAndNightConfig(index: indexPath.row)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placeholder = ["오늘 아침! 당신의 한줄은 무엇인가요?", "오늘 밤! 당신의 한줄은 무엇인가요?"]
       
        guard let diaryLabel = self.cell!.diaryLabel.text else {
            // 여기서 cell 프로퍼티에 밤일기가 마지막으로 들어와있ㅇ
            print(self.cell!.diaryLabel.text!)
            self.cell!.diaryLabel.text = placeholder[indexPath.row]
            return
        }
        
        print("=====>", diaryLabel)
        print("=====>", placeholder[indexPath.row])
        print("====>", testCelllist)
        
        if testCelllist[indexPath.row] == placeholder[indexPath.row] {
            print("====>🚀 작성화면으로 가기")
            
            setWritModeAndTransition(.newDiary, diaryType: .allCases[indexPath.row], task: nil)
            
        } else {
            //해당 날짜와 같은 칼럼을 넘겨줌
            print("====>🚀 수정화면으로 가기")
            setWritModeAndTransition(.modified, diaryType: .allCases[indexPath.row], task: dateFilterTask)
            
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
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: MainList?) {
        let vc = WriteViewController(diarytype: diaryType, writeMode: mode)
        vc.data = task
        vc.fetch = fetchRealm
        
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
extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let PreparingCell = MainTableViewCell()
        dateFilterTask = MainListRepository.shared.fetchDate(date: date)[0]
        tasks = MainListRepository.shared.fetchDate(date: date)
        // 여기서 디자인해놓은 것들 반영하기
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
extension MainViewController {
    
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
        viewModel.morningDiaryCount.value = changeMorningcount
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
        viewModel.nightDiaryCount.value = changeNightcount
        
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
