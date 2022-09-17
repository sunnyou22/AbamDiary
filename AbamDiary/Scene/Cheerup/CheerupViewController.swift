//
//  CheerupViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit
import RealmSwift

class CheerupViewController: BaseViewController {
    
    var cheerupView = CheerupView()
    var tasks: Results<CheerupMessage>! {
        didSet {
            cheerupView.tableView.reloadData()
            print("♻️ 응원메세지뷰컨 리로등~")
        }
    }
    
    override func loadView() {
        view = cheerupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cheerupView.tableView.delegate = self
//        cheerupView.tableView.dataSource = self
    }
}
//
//extension CheerupViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        <#code#>
//    }
//
//
//}
