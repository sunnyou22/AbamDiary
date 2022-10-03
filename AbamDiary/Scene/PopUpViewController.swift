//
//  PopUpViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/21.
//

import UIKit
import SnapKit

class PopUpViewController: BaseViewController {
    
    let popView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        view.clipsToBounds = true
        view.layer.cornerRadius = 32
        return view
    }()
    
    let morningDiaryCount: UILabel = {
        let view = UILabel()
        let count = Int(CalendarViewController.gageCountModel.morningDiaryCount.value)
        view.text = "아침일기: \(count)개"
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        return view
    }()
    
    let nightDiaryCount: UILabel = {
        let view = UILabel()
        let count = Int(CalendarViewController.gageCountModel.nightDiaryCount.value)
        view.text = "저녁일기: \(count)개"
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        return view
    }()
    
    //특정범위의 문자만 속성적용
    let resultLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    let profileimageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .systemGray5
      
        DispatchQueue.main.async {
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = 30
        }
       
        return view
    }()
    
    let profileBackView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "popImage")
       
         return view
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isOpaque = false
        
        profileimageView.image = loadImageFromFolder(fileName: "profile.jpg", folderName: .imageFoler)
        swipeDown()
        self.navigationController?.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setValueOfView() {
        setResultLabel(resultLabel)
    }
    
    override func configuration() {
        [morningDiaryCount, nightDiaryCount, resultLabel, profileBackView, profileimageView].forEach { popView.addSubview($0) }
        view.addSubview(popView)
    }
    
    override func setConstraints() {
        
        popView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(240)
            make.height.equalTo(240)
            
        }
        
        morningDiaryCount.snp.makeConstraints { make in
            make.bottom.equalTo(nightDiaryCount.snp.top).offset(-8)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        nightDiaryCount.snp.makeConstraints { make in
            make.bottom.equalTo(resultLabel.snp.top).offset(-30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
        
        profileimageView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
      
        profileBackView.snp.makeConstraints { make in
            make.bottom.equalTo(profileimageView.snp.bottom)
            make.trailing.equalTo(profileimageView.snp.trailing).offset(8)
            make.width.equalTo(profileimageView.snp.width).multipliedBy(1.1)
            make.height.equalTo(profileimageView.snp.height).multipliedBy(1.1)
        }
    }
    
    //MARK: - 메서드
    func setResultLabelComponent(m: Float, n: Float) -> String? {
        
        if m > n {
            return "아침형"
        } else if m < n {
            return "저녁형"
        } else if  m == n, m != 0, n != 0 {
            return "균형왕"
        } else {
            return nil
        }
    }
    
    func setResultLabel(_ view: UILabel) {
        let m = CalendarViewController.gageCountModel.morningDiaryCount.value
        let n = CalendarViewController.gageCountModel.nightDiaryCount.value
        
        guard let result = setResultLabelComponent(m: m, n: n) else {
            view.text = "어떤 아밤인지 모르겠어요 🤔"
            return
        }
        
        let attributeString = NSMutableAttributedString(string: "당신은 \(result) 아밤이궁요!")
        switch result {
        case "아침형":
            attributeString.addAttributes([.foregroundColor: Color.BaseColorWtihDark.popupViewLabel(type: .morning)], range: NSRange(location: 4, length: 3))
        case "저녁형":
            attributeString.addAttributes([.foregroundColor: Color.BaseColorWtihDark.popupViewLabel(type: .night)], range: NSRange(location: 4, length: 3))
        default:
            attributeString.addAttributes([.foregroundColor: Color.BaseColorWtihDark.popupViewLabel(type: .morning)], range: NSRange(location: 4, length: 3))
        }
        
        view.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
        view.attributedText = attributeString
    }
    
}

extension PopUpViewController {
    
    func swipeDown () {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondSwipe(_:)))
        swipe.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func respondSwipe(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismiss(animated: true)
            default: break
            }
        }
    }
}
