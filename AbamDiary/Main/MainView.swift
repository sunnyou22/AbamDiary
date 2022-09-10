//
//  MainView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import FSCalendar

class MainView: BaseView {
    
    let ABAMImage: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "ABAM")
       return view
    }()
    
    let cheerupMessage: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.subTitle_16, weight: .semibold)
        view.textColor = Color.BaseColorWtihDark.cheerupMessege
        
        return view
    }()
    
    let calendar: FSCalendar = {
        let view = FSCalendar()
        return view
    }()
     
    let cellTitle: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.largeTitle_20, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    let gageTitle: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: FontSize.largeTitle_20, weight: .bold)
        view.textColor = Color.BaseColorWtihDark.backgorund
        return view
    }
    
    override func configuration() {
       self.addSubview(calendar)
    }
    
    
}
