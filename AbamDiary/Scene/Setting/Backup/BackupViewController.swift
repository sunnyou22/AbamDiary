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

//디퍼플을 상속받는 클래스 만들어주기
class DataSource: UITableViewDiffableDataSource<Section, Id> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. get the current snapshot
            var snapshot = self.snapshot()
           // 해당인덱스에 있는 식별자 반환
            if let item = itemIdentifier(for: indexPath) {
              // 3. delete the item from the snapshot
              snapshot.deleteItems([item])
              // 4. apply the snapshot (apply changes to the datasource which in turn updates the table view)
              apply(snapshot, animatingDifferences: true)
             }
           }
         }

         // 1. reordering steps
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           return true
         }

         // 2. reordering steps
         override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           //움직이려는 아이템
           guard let sourceItem = itemIdentifier(for: sourceIndexPath) else { return }

           // 목표지점하고 다름
           guard sourceIndexPath != destinationIndexPath else {
             // if the source and destination are the same
             print("move to self")
             return
           }

           // 목표지점의 식별자
           let destinationItem = itemIdentifier(for: destinationIndexPath)

           // get the current snapshot
           var snapshot = self.snapshot()

           // handle SCENARIO 2 AND 3
           if let destinationItem = destinationItem {

             // 식별자의 인덱스도 구할 수 있음
             if let sourceIndex = snapshot.indexOfItem(sourceItem), let destinationIndex = snapshot.indexOfItem(destinationItem) {

               // what order should we be inserting the source item 같은 섹션에 넣어야함
               let isAfter = destinationIndex > sourceIndex && snapshot.sectionIdentifier(containingItem: sourceItem) ==
               snapshot.sectionIdentifier(containingItem: destinationItem)
               // first delete the source item from the snapshot
               snapshot.deleteItems([sourceItem])

               // SCENARIO 2
               if isAfter {
                 print("after destination")
                 snapshot.insertItems([sourceItem], afterItem: destinationItem)
               }

               // SCENARIO 3
               else {
                 print("before destination")
                 snapshot.insertItems([sourceItem], beforeItem: destinationItem)
               }
             }

           }

           // handle SCENARIO 4
           // no index path at destination section
           else {
             print("new index path")
             // get the section for the destination index path
             let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]

             // delete the source item before reinserting it
             snapshot.deleteItems([sourceItem])

             // append the source item at the new section
             snapshot.appendItems([sourceItem], toSection: destinationSection)
           }

           // apply changes to the data souce
           apply(snapshot, animatingDifferences: false)
         }


       }


class BackupViewController: BaseViewController {
    
    var backupView = BackupView()
    var hashableList: [String] = []
    
    lazy var arr: [Id] = {
        return self.hashableList.map { Id(name: $0) }
    }()
    
    var dataSource: DataSource!
    
    func configureNavBar() {
        navigationItem.title = "백업/복구"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditState))
     
      }
      
    func configureTableView() {
        backupView.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @objc private func toggleEditState() {
      // 1. false  -> 2. true -> 3. false
      
      // 1. !isEditing = false -> true
      // 2. !isEditing = true -> false
      // 3. !isEditing = false -> true
      
        backupView.tableView.setEditing(!backupView.tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = backupView.tableView.isEditing ? "Done" : "Edit"
      
  //    if tableView.isEditing {
  //      navigationItem.leftBarButtonItem?.title = "Done"
  //    } else {
  //      navigationItem.leftBarButtonItem?.title = "Edit"
  //    }
    }
    
    override func loadView() {
        view = backupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backupView.backupFileButton.addTarget(self, action: #selector(clickedBackupButton), for: .touchUpInside)
       setDataSource()
        configureNavBar()
        configureTableView()
    }
    
    @objc func clickedBackupButton() {
        setTextData(text: backupView.backupFileNameTextField.text ?? "")
    }
    
    // 스냅샷에서 데이터를 뽑아와서 셀에 보여지는 것
    func setDataSource() {
        self.dataSource = DataSource(tableView: backupView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else {
                preconditionFailure()
            }
            cell.subTitle.text = itemIdentifier.name
            
            return cell
        })
    }
       
    //셀에 들어갈 데이터 즉 스냅샷
    func setTextData(text: String) {
        arr.append(Id(name: text))
        var snapshot = NSDiffableDataSourceSnapshot<Section, Id>()
        snapshot.appendSections([.main])
        snapshot.appendItems(arr)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
