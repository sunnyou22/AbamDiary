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
        view.text = "아침일기: 88개"
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        return view
    }()
    
    let nightDiaryCount: UILabel = {
        let view = UILabel()
        view.text = "저녁일기: 88개"
        view.font = UIFont.systemFont(ofSize: FontSize.label_14, weight: .medium)
        return view
    }()
    
    //특정범위의 문자만 속성적용
    let resultLabel: UILabel = {
        let view = UILabel()
        let attributeString = NSMutableAttributedString(string: view.text ?? "당신은 ㅁㅁㅁ 아밤이궁요!")
        view.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        attributeString.addAttributes([.foregroundColor: UIColor.blue], range: NSRange(location: 4, length: 3))
        view.attributedText = attributeString
        
        return view
    }()
    
    let profileimageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .systemGray5
      
        DispatchQueue.main.async {
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.layer.cornerRadius = 30
            print("-----이미지 깎기", view.frame.size.height)
        }
       
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isOpaque = false
        swipeDown()
        
        profileimageView.image = loadImageFromDocument(fileName: "profile.jpg")
        print("이미지 받아오기")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configuration() {
        [morningDiaryCount, nightDiaryCount, resultLabel, profileimageView].forEach { popView.addSubview($0) }
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
        print("제약조건", profileimageView.frame.size.width)
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
