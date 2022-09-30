//
//  BackupViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/01.
//

import Foundation
import UIKit

struct Id: Hashable {
    let id = UUID()
    var name: String
}

enum Section: CaseIterable {
       case main
   }

class BackupViewController: BaseViewController {
    
    var backupView = BackupView()
    var hashableList: [String]?
    lazy var arr: [Id] = {
        return self.hashableList.map { Id(name: $0) }
    }()
    
    override func loadView() {
        view = backupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupView.tableView.delegate = self
//        backupView.
    }
}
