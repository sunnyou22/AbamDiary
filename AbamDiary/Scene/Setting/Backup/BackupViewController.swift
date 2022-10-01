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
    var hashableList: [String] = []
    
    lazy var arr: [Id] = {
        return self.hashableList.map { Id(name: $0) }
    }()
    
    var dataSource: UITableViewDiffableDataSource<Section, Id>!
    
    override func loadView() {
        view = backupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupView.backupFileButton.addTarget(self, action: #selector(clickedBackupButton), for: .touchUpInside)
       setDataSource()
    }
    
    @objc func clickedBackupButton() {
        setTextData(text: backupView.backupFileNameTextField.text ?? "")
    }
    
    // 스냅샷에서 데이터를 뽑아와서 셀에 보여지는 것
    func setDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, Id>(tableView: backupView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else {
                preconditionFailure()
            }
            cell.subTitle.text = itemIdentifier.name
            
            return cell
        })
    }
    
    //셀에 들어갈 데이터 즉 스냅샷
    func setTextData(text: String) {
        let contents = [Id(name: text)]
        var snapshot = NSDiffableDataSourceSnapshot<Section, Id>()
        snapshot.appendSections([.main])
        snapshot.appendItems(contents)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
