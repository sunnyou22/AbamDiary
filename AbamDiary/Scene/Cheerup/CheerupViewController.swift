//
//  CheerupViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import Foundation

class CheerupViewController: BaseViewController {
    
    var cheerupView = CheerupView()
    
    override func loadView() {
        view = cheerupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
