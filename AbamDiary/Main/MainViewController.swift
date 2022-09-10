//
//  MainViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
import FSCalendar

class MainViewController: BaseViewController {
    
    let mainview = MainView()
    
    override func loadView() {
        self.view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ABAM"
        mainview.calendar.dataSource = self
        mainview.calendar.delegate = self
        
    }
}

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}
