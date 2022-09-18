//
//  CheeupView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/17.
//

import UIKit
import SnapKit

class CheerupView: BaseView {
    
    let title: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "cheerupTitle")
        
        return view
    }()
    
    let subTitle: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cheerupSubTitle")

        return view
    }()
    
    let roundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cheerup")!
        return view
    }()
    
    let textField: UITextField = {
       let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(string: "응원의 메세지를 적어보세요", attributes: [NSAttributedString.Key.foregroundColor : Color.BaseColorWtihDark.cheerupMsgPlaceholder, NSAttributedString.Key.font : UIFont.systemFont(ofSize: FontSize.subTitle_16, weight: .bold)])
        return view
    }()
                                                                                     
    let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
    
    let birdButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "blueBird"), for: .normal)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let countLabel: UILabel = {
        let view = UILabel()
        view.textColor = Color.BaseColorWtihDark.messageCount
        view.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        view.text = "8"
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        view.layer.borderColor = Color.BaseColorWtihDark.thineBar.cgColor
        view.layer.borderWidth = 1
        view.separatorStyle = .none
        view.register(CheerupTableViewCell.self, forCellReuseIdentifier: CheerupTableViewCell.reuseIdentifier)
        view.isScrollEnabled = true
        
        DispatchQueue.main.async {
            view.clipsToBounds = true
            view.layer.cornerRadius = 16
        }
        
        return view
    }()
    
    override func configuration() {
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
        [textFieldView, roundImage, textField, subTitle, title, birdButton, countLabel, tableView].forEach { self.addSubview($0) }
    }

    override func setConstraints() {
        
        title.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.bottom.equalTo(subTitle.snp.top).offset(-52)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        subTitle.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(roundImage.snp.top).offset(-80)
            make.width.equalTo(self.snp.width).dividedBy(1.8)
            make.height.equalTo(subTitle.snp.width).dividedBy(2.9)
            make.leading.equalTo(roundImage.snp.leading)
        }
        
        roundImage.snp.makeConstraints { make in
            make.bottom.equalTo(textFieldView.snp.bottom).offset(9)
            make.trailing.equalTo(textFieldView.snp.leading).offset(34)
            make.width.equalTo(self.snp.width).dividedBy(7)
            make.height.equalTo(roundImage.snp.width)
        }
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(textFieldView.snp.top).offset(-4)
            make.leading.equalTo(textFieldView.snp.leading).offset(2)
            make.trailing.equalTo(textFieldView.snp.trailing)
        }
        
        textFieldView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(60)
            make.height.equalTo(1)
        }
        
        birdButton.snp.makeConstraints { make in
            make.bottom.equalTo(textFieldView.snp.top).offset(4)
            make.trailing.equalTo(textFieldView.snp.trailing).offset(16)
            make.size.equalTo(roundImage.snp.size).multipliedBy(0.9)
        }
        
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(birdButton.snp.top).offset(12)
            make.centerX.equalTo(birdButton.snp.centerX).inset(-8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(roundImage.snp.bottom).offset(28)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(28)
        }
    }
}
