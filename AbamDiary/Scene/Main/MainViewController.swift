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
        let digit: Double = pow(10, 2) // 10의 2제곱
        
    //어차피 애니메이션들어가면 변경된 값이 계속 들어감 -> 디바이스 대응
        let testM = self.mainview.morningBar.frame.size.width
        let testN = self.mainview.nightBar.frame.size.width
        let moringCountRatio: Double = round((self.changeMorningcount / (self.viewModel.morningDiaryCount.value + self.viewModel.nightDiaryCount.value)) * digit) / digit
        let nightCountRatio: Double = round((self.changeNightcount / (self.viewModel.morningDiaryCount.value + self.viewModel.nightDiaryCount.value)) * digit) / digit
        
        //사이드에 뷰를 넣어버릴까
        UIView.animate(withDuration: 0) {
            if moringCountRatio > nightCountRatio {
                if moringCountRatio == 1 {
                    self.mainview.morningBar.transform = CGAffineTransform(a: 2, b: 0, c: 0, d: 1, tx: testM / 2, ty: 0)
                } else if moringCountRatio > 0.5 {
                    print("🟢===> 아침 두번째 조건", moringCountRatio)
                    self.mainview.morningBar.transform = CGAffineTransform(scaleX: 1 + moringCountRatio, y: 1)
                    self.mainview.nightBar.transform = CGAffineTransform(scaleX: 1 - moringCountRatio, y: 1)
                    self.mainview.morningBar.frame.origin.x = 24
                    self.mainview.nightBar.frame.origin.x = self.mainview.morningBar.frame.size.width
                    
                    print(moringCountRatio)
                print("====> 모닝바 너비", self.mainview.morningBar.frame.size.width)
                    print("====> 저녁바 엑스좌표", self.mainview.nightBar.bounds.origin.x)
                }
            } else if moringCountRatio < nightCountRatio {
                
            } else {
                self.mainview.morningBar.transform = .identity
                self.mainview.nightBar.transform = .identity
                print("🔴====> 바를 움직일 수 없습니다")
            }
            
        } completion: { _ in
            if moringCountRatio == 1{
                self.mainview.morningBar.transform = .identity
                self.mainview.morningBar.transform = CGAffineTransform(a: 2, b: 0, c: 0, d: 1, tx: self.mainview.morningBar.frame.size.width / 2, ty: 0)
            } else if moringCountRatio > 0.5 {
                print("🟢===> 아침 두번째 조건", moringCountRatio)
                self.mainview.morningBar.transform = CGAffineTransform(scaleX: (1 + moringCountRatio), y: 1)
                self.mainview.nightBar.transform = CGAffineTransform(scaleX: (1 - moringCountRatio), y: 1)
                self.mainview.nightBar.bounds.origin.x = self.mainview.morningBar.frame.size.width
                self.mainview.morningBar.frame.origin.x = 24
            print("====> 모닝바 너비", self.mainview.morningBar.frame.size.width)
                print("====> 저녁바 엑스좌표", self.mainview.nightBar.bounds.origin.x)
            }
           
            
        }
        
    }
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


//UIView.animate(withDuration: 1) {
//
//    if moringCountRatio != 0, moringCountRatio < 0.5 {
//        self.mainview.morningBar.transform = CGAffineTransform(scaleX: 1 + moringCountRatio, y: 1)
//        self.mainview.nightBar.transform = CGAffineTransform(scaleX: (1 - moringCountRatio), y: 1)
//        print("🔴 ====> 1번 조건", moringCountRatio)
//    } else if moringCountRatio != 0, moringCountRatio > 0.5 {
//
//        self.mainview.morningBar.transform = CGAffineTransform(scaleX: 1 + moringCountRatio, y: 1)
//        self.mainview.nightBar.transform = CGAffineTransform(scaleX: (1 - moringCountRatio), y: 1)
//        print("🔴 ====> 2번조건C", moringCountRatio)
//        print("🔴 ====> 2번조건C moringCountRatio", moringCountRatio)
//        print("🔴 ====> 2번조건C width", self.mainview.morningBar.frame.size.width)
//    } else if moringCountRatio == 0 {
//        self.mainview.morningBar.frame.size.width = (UIScreen.main.bounds.width - 48) / 2
//        print("🔴 ====> 3번조건", moringCountRatio)
//    } else {
//        print("🔴 ====> 바를 움직일 수 없습니다", moringCountRatio)
//    }
//
//
//} completion: { _ in
//
//        if moringCountRatio != 0, moringCountRatio < 0.5 {
//
//            self.mainview.nightBar.transform = CGAffineTransform(scaleX: (1 - moringCountRatio), y: 1)
//
//            print("🔴 ====> 1번 조건", moringCountRatio)
//        } else if moringCountRatio != 0, moringCountRatio > 0.5 {
//            self.mainview.morningBar.transform = CGAffineTransform(scaleX: 1 + moringCountRatio, y: 1).translatedBy(x: 0, y: 0)
//
//            self.mainview.nightBar.transform = CGAffineTransform(scaleX: (1 - moringCountRatio), y: 1)
//            print("🔴 ====> 2번조건C", moringCountRatio)
//            print("🔴 ====> 2번조건C moringCountRatio", moringCountRatio)
//            print("🔴 ====> 2번조건C width", self.mainview.morningBar.frame.size.width)
//
//        } else if moringCountRatio == 0 {
//            self.mainview.morningBar.frame.size.width = (UIScreen.main.bounds.width - 48) / 2
//            print("🔴 ====> 3번조건", moringCountRatio)
//        } else {
//            print("🔴 ====> 바를 움직일 수 없습니다", moringCountRatio)
//        }
//}          }
//}
