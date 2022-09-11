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
    var changeMorningcount: Double = 0
    var changeNightcount: Double = 0
    
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
        viewModel.morningDiaryCount.value = changeMorningcount
        animateMorningBar()
    }
    
    @objc func testPlusN() {
        self.changeNightcount += 20.0
        viewModel.nightDiaryCount.value = changeNightcount
        animateMorningBar()
    }
    
    func animateMorningBar() {
        let digit: Double = pow(10, 2) // 10의 3제곱
        let moringCountRatio: Double = round((self.changeMorningcount / (self.viewModel.morningDiaryCount.value + self.viewModel.nightDiaryCount.value)) * digit) / digit
        
        UIView.animate(withDuration: 1) {
        
            if moringCountRatio != 0, moringCountRatio < 0.5 {
                self.mainview.morningBar.frame.size.width *= moringCountRatio
                print("🔴 ====> 1번 조건", moringCountRatio)
            } else if moringCountRatio != 0, moringCountRatio > 0.5 {
               
                self.mainview.morningBar.transform = CGAffineTransform(scaleX: 2, y: 1)
                self.mainview.morningBar.frame.size.width *= (1 + moringCountRatio)
                
            } else if moringCountRatio == 0 {
                self.mainview.morningBar.frame.size.width = (UIScreen.main.bounds.width - 48) / 2
                print("🔴 ====> 3번조건", moringCountRatio)
            } else {
                print("🔴 ====> 바를 움직일 수 없습니다", moringCountRatio)
            }


        } completion: { _ in
          
                if moringCountRatio != 0, moringCountRatio < 0.5 {
                    self.mainview.morningBar.frame.size.width *= moringCountRatio
                    
                    print("🔴 ====> 1번 조건", moringCountRatio)
                } else if moringCountRatio != 0, moringCountRatio > 0.5 {
                    self.mainview.morningBar.frame.size.width *= (1 + moringCountRatio)
                    print("🔴 ====> 2번조건", moringCountRatio)
                    print("🔴 ====> 2번조건 moringCountRatio", moringCountRatio)
                    print("🔴 ====> 2번조건 width", self.mainview.morningBar.frame.size.width)

                } else if moringCountRatio == 0 {
                    self.mainview.morningBar.frame.size.width = (UIScreen.main.bounds.width - 48) / 2
                    print("🔴 ====> 3번조건", moringCountRatio)
                } else {
                    print("🔴 ====> 바를 움직일 수 없습니다", moringCountRatio)
                }
        }          }
        }
    
    
//    func animateProfileImageView() {
//        UIView.animate(withDuration: 1) {
//            self.mainview.profileImage.transform = CGAffineTransform(translationX: <#T##CGFloat#>, y: <#T##CGFloat#>)
//        } completion: { _ in
//            <#code#>
//        }
//
//    }


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
