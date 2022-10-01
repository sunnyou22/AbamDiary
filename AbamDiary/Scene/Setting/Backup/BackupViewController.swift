//
//  BackupViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/01.
//

import Foundation
import UIKit
import Toast
import RealmSwift

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
//
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 현재스냅샷
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
         }


class BackupViewController: BaseViewController {
    
    static let shared = BackupViewController()
    
    var backupView = BackupView()
    var hashableList: [String] = []
    var tasks: Results<Diary>!
    var cheerupTasks: Results<CheerupMessage>!
    lazy var arr: [Id] = {
        return self.hashableList.map { Id(name: $0) }
    }()
    
    var dataSource: DataSource!
    
    var cell: UITableViewCell?
    
    func configureNavBar() {
        navigationItem.title = "백업/복구"
     
      }
   
    override func loadView() {
        view = backupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backupView.tableView.delegate = self
        
        backupView.backupFileButton.addTarget(self, action: #selector(clickedBackupButton), for: .touchUpInside)
       setDataSource()
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetch()
    }
    
    func fetch() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
        cheerupTasks = CheerupMessageRepository.shared.fetchDate(ascending: false)
    }
    
    @objc func clickedBackupButton() {
        
        guard let text = backupView.backupFileNameTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            backupView.makeToast("메세지를 다시 입력해주세요", duration: 0.5, position: .center)
            return
        }
        setTextData(text: text)
    }
    
    // 스냅샷에서 데이터를 뽑아와서 셀에 보여지는 것
    func setDataSource() {
        self.dataSource = DataSource(tableView: backupView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else {
                preconditionFailure()
            }
            cell = cell
            cell.subTitle.text = itemIdentifier.name
            
            return cell
        })
    }
       
    //셀에 들어갈 데이터 즉 스냅샷 + 백업
    func setTextData(text: String) {
        var snapshot = dataSource.snapshot()
        
        guard arr.filter({ id in
            snapshot.itemIdentifiers.contains(id)
        }).isEmpty else {
            backupView.makeToast("기존 파일명은 사용할 수 없습니다!", duration: 0.8, position: .center)
            return
        }
        
        arr.append(Id(name: text))
        
        do {
            let backupFilePth = try createBackupFile(fileName: text)
            try showActivityViewController(backupFileURL: backupFilePth)
            fetchDocumentZipFile()
            snapshot.appendSections([.main])
            snapshot.appendItems(arr)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        catch {
            backupView.makeToast("압축에 실패하였습니다")
        }
    }
 
    
    func clickRestoreCell(text: String) {
        
        let alert = UIAlertController(title: "알림", message: "현재 일기에 덮어씌워집니다. 진행하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { [weak self]_ in
            
            guard let self = self else { return }
            
            guard let path = self.documentDirectoryPath() else {
                print("도큐먼트 위치에 오류가 있습니다.")
                return
            }
            
            OneDayDiaryRepository.shared.deleteTasks(tasks: self.tasks)
            CheerupMessageRepository.shared.deleteTasks(tasks: self.cheerupTasks)
            
            if FileManager.default.fileExists(atPath: path.path) {
                let fileURL = path.appendingPathComponent(text)
                
                do {
                    
                    
                    let doucumentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
                    doucumentPicker.delegate = self
                    doucumentPicker.allowsMultipleSelection = false
                    self.present(doucumentPicker, animated: true)
              
                    try self.restoreRealmForBackupFile()
                }
                catch {
                    print("압축에 실패하였습니다")
                }
            }
//복구완료 얼럿넣기
                self.tabBarController?.selectedIndex = 0
        }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func fetchCell(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> CalendarTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return CalendarTableViewCell()}
        self.cell = cell
        
        return cell
    }
}

extension BackupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        guard let text = cell.subTitle.text else {
//            print("🔴 해당셀의 레이블은 nil입니다.")
//            return
//        }
        
//        clickRestoreCell(text: cell.sub)
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐머트픽커 닫음", #function)
    }
    
    //
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) { // 어떤 압축파일을 선택했는지 명세
        
        //파일앱에서 선택한 filURL
        guard let selectedFileURL = urls.first else {
            print("선택하진 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        //
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        //여기서 앱의 백업복구 파일과 같은지 비교
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let filename_zip = selectedFileURL.lastPathComponent
            print(filename_zip, "========🚀🚀🚀🚀🚀")
            
            let zipfileURL = path.appendingPathComponent(filename_zip)
  print(zipfileURL)
           
            do {
                try unzipFile(fileURL: zipfileURL, documentURL: path)
                do {
                    let Dfetch = try DfetchJSONData()
                    let Cfetch = try CfetchJSONData()
                    try decoedDiary(Dfetch)
                    try decoedCheerup(Cfetch)
                    fetchDocumentZipFile()
                } catch {
                    print("복구실패~~~")
                }
            } catch {
                print("압축풀기 실패 다 이놈아~~~===============")
            }
        } else {
            
            do {
                //파일 앱의 zip -> 도큐먼트 폴더에 복사(at:원래경로, to: 복사하고자하는 경로) / sandboxFileURL -> 걍 경로
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let filename_zip = selectedFileURL.lastPathComponent
                let zipfileURL = path.appendingPathExtension(filename_zip)

                do {
                    try unzipFile(fileURL: zipfileURL, documentURL: path)
                    do {
                        let Dfetch = try DfetchJSONData()
                        let Cfetch = try CfetchJSONData()
                        try decoedDiary(Dfetch)
                        try decoedCheerup(Cfetch)
                    } catch {
                        print("복구실패~~~")
                    }
                } catch {
                    print("압축풀기 실패 다 이놈아~~~")
                }
            } catch {
                print("🔴 압축 해제 실패")
            }
        }
    }
}
