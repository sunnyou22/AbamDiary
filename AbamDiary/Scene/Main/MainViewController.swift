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
    
    var tasks: Results<MainList>! {
        didSet {
            mainview.tableView.reloadData()
            dateFilterTask
        }
    }
    
    var dateFilterTask: MainList? // 캘린더에 해당하는 날짜를 받아오기 위함
    
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
    }
    
    func fetchRealm() {
        tasks = MainListRepository.shared.fetchLatestOrder()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        if dateFilterTask != nil {
            if indexPath.row == 0 {
                cell.diaryLabel.text = dateFilterTask?.mornimgDiary
            } else {
                cell.diaryLabel.text = dateFilterTask?.nightDiary
            }
        } else {
            cell.diaryLabel.text = cell.setMainCellPlaceholder(type: .allCases[indexPath.row])
        }
        cell.setMornigAndNightConfig(index: indexPath.row)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return }
      
        let placeholder = cell.setMainCellPlaceholder(type: .allCases[indexPath.row])
        
        guard let diaryLabel = cell.diaryLabel.text else {
            cell.diaryLabel.text = placeholder
            return
        }
        
        print(cell.diaryLabel.text)
        
        if diaryLabel == placeholder {
            setWritModeAndTransition(.newDiary, diaryType: .allCases[indexPath.row], task: nil)
            viewModel.diaryTextView.bind { text in
                cell.diaryLabel.text = text
            }
        } else {
            //해당 날짜와 같은 칼럼을 넘겨줌
            setWritModeAndTransition(.modified, diaryType: .allCases[indexPath.row], task: dateFilterTask)
            viewModel.diaryTextView.bind { text in
                cell.diaryLabel.text = text
            }
        }
    }
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: MainList?) {
        let vc = WriteViewController(diarytype: diaryType)
        vc.data = task
        
        switch mode {
        case .newDiary:
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
            transition(vc, transitionStyle: .push)
            vc.navigationItem.title = "수정"
            
        }
        
    }
}
    //MARK: - 메서드
   
    
//MARK: 캘린더 디자인하기
extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
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
        
        print(moringCountRatio, "----")

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
