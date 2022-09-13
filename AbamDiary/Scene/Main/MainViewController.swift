//
//  MainViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import FSCalendar
import SnapKit

class MainViewController: BaseViewController {
    
    let mainview = MainView()
    //MARK: observable 변경하기
    var viewModel = GageModel()
    var changeMorningcount: Float = 0
    var changeNightcount: Float = 0
    var progress: Float = 0
    let digit: Float = pow(10, 2) // 10의 2제곱
    
    override func loadView() {
        self.view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //나중에 함수로 빼기
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
  
//램 데이터 기반으로 바꾸기
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainview.tableView.frame.height / 2.2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.setMornigAndNightConfig(index: indexPath.row)
        cell.backgroundColor = .clear
        cell.isHighlighted = false
        cell.isSelected = false
        return cell
    }
    
    //MARK: - 메서드
    
    //네비게이션 이동 메서드
    func foWriteVC(to: MorningAndNight, tasks: MainList) {
        let vc = WriteViewController(type: to)
        vc.data = tasks
        transition(vc, transitionStyle: TransitionStyle.push)
    }
}

//MARK: 캘린더 디자인하기
extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {

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
