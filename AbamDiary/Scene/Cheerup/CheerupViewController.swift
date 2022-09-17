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
          fetchRealm()
            cheerupView.tableView.reloadData()
            print("♻️ 응원메세지뷰컨 리로등~")
        }
    }
    
    override func loadView() {
        view = cheerupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cheerupView.tableView.delegate = self
        cheerupView.tableView.dataSource = self
        cheerupView.birdButton.addTarget(self, action: #selector(insertMessage), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
    }
    //MARK: 메서드
    
    func fetchRealm() {
       tasks = CheerupMessageRepository.shared.fetchDate()
    }
    
    @objc func insertMessage() {
        guard let text = cheerupView.textField.text else {
            let alert = UIAlertController(title: nil, message: "글자를 입력해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "👌", style: .default)
            
            alert.addAction(ok)
            present(alert, animated: true)
            return
        }
        
        let task = CheerupMessage(cheerup: text, date: Date())
        CheerupMessageRepository.shared.addItem(item: task)
    }
}

extension CheerupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: CheerupTableViewCell.reuseIdentifier, for: indexPath) as? CheerupTableViewCell else {
            return UITableViewCell()
        }
     
        let item = tasks[indexPath.row]
        
        cell.message.text = item.cheerup
        cell.dateLabel.text = CustomFormatter.setCheerupDate(date: Date())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = tasks[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            CheerupMessageRepository.shared.deleteRecord(item: item)
            self.cheerupView.tableView.reloadData()
            self.fetchRealm()
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
