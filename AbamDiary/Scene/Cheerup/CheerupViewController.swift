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
    var countMessageModel = CountMessage()
    var tasks: Results<CheerupMessage>! {
        didSet {
            cheerupView.tableView.reloadData()
            print("♻️ 응원메세지뷰컨 리로등~")
        }
    }
    
    let sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.BaseColorWtihDark.thineBar
        return view
    }()
    
    override func loadView() {
        view = cheerupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
        cheerupView.tableView.delegate = self
        cheerupView.tableView.dataSource = self
        cheerupView.birdButton.addTarget(self, action: #selector(insertMessage), for: .touchUpInside)
        navigationItem.titleView?.accessibilityScroll(.up)
        
        //메세지 초기화
        let reset = UIBarButtonItem(title: "초기화", style: .plain, target: self, action: #selector(resetMessage))
        self.navigationItem.rightBarButtonItem = reset
    }
    
    @objc func resetMessage() {
        let alert = UIAlertController(title: "알림", message: "정말 모든 데이터를 삭제하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .destructive) {_ in
            CheerupMessageRepository.shared.deleteTasks(tasks: self.tasks)
            self.cheerupView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRealm()
        print("Realm is located at:", CheerupMessageRepository.shared.localRealm.configuration.fileURL!)
        
        countMessageModel.count.bind { value in
            self.cheerupView.countLabel.text = "\(value)"
        }
        
        cheerupView.countLabel.text = "\(tasks.count)"
       
        // tap 제스처 알아보기
//        cheerupView.addGestureRecognizer(.init(target: self, action: #selector(downKeyboard())))
        cheerupView.textField.addTarget(self, action: #selector(downKeyboard), for: .editingDidEndOnExit)
                                               
    }
    //MARK: 메서드

    func fetchRealm() {
        tasks = CheerupMessageRepository.shared.fetchDate()
    }
    
    @objc func insertMessage() {
        guard let text = cheerupView.textField.text else {
            return
        }
        
        if text.isEmpty {
            let alert = UIAlertController(title: nil, message: "글자를 입력해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.cheerupView.textField.text = nil
            }
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: "파랑새에게 전송할까요?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "전송", style: .default) { _ in
                let task = CheerupMessage(cheerup: text, date: Date())
                CheerupMessageRepository.shared.addItem(item: task)
                self.cheerupView.tableView.reloadData()
                self.countMessageModel.count.value = self.tasks.count
                
                self.cheerupView.textField.text = nil
            }
            let cancel = UIAlertAction(title: "취소", style: .default)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
    }
    
    @objc func downKeyboard() {
        cheerupView.textField.resignFirstResponder()
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
        
        cell.setCheerupTableCellConfig(leftLabel: cell.title, right: cell.subTitle)
        
        cell.subTitle.text = item.cheerup
        cell.title.text = CustomFormatter.setCheerupDate(date: Date())
        
        cell.contentView.addSubview(sectionView)
        
        sectionView.snp.makeConstraints { make in
            make.leading.equalTo(cell.labelContainView.snp.trailing).offset(0)
            make.verticalEdges.equalTo(cell.contentView.snp.verticalEdges)
            make.width.equalTo(1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = tasks[indexPath.row]
        
        let delete = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            CheerupMessageRepository.shared.deleteRecord(item: item)
            self.fetchRealm()
            self.countMessageModel.count.value = self.tasks.count
            self.cheerupView.tableView.reloadData()
            
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
