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
import FirebaseAnalytics

class BackupViewController: BaseViewController {
    
    static let shared = BackupViewController()
    
    var backupView = BackupView()
    var hashableList: [String] = []
    var tasks: Results<Diary>!
    var cheerupTasks: Results<CheerupMessage>!
    var backupfiles: [String]?
    
    deinit {
        print("=========================================백업창 디이닛 🔴🔴🔴🔴")
    }
    
    func configureNavBar() {
        navigationItem.title = "백업/복구"
        self.navigationController?.navigationBar.tintColor = Color.BaseColorWtihDark.navigationBarItem
    }
    
    override func loadView() {
        view = backupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backupView.tableView.delegate = self
        backupView.tableView.dataSource = self
        fetchBackupFileList()
        configureNavBar()
        
        backupView.backupFileButton.addTarget(self, action: #selector(clickedBackupButton), for: .touchUpInside)
        backupView.restoreFileButton.addTarget(self, action: #selector(clickRestoreCell), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetch()
        fetchBackupFileList()
    }
    
   private func fetchBackupFileList() {
        backupfiles = fetchDocumentZipFile().sorted(by: >)
    }
    
    private func fetch() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
        cheerupTasks = CheerupMessageRepository.shared.fetchDate(ascending: false)
    }
    
    @objc private func clickedBackupButton() {
        setTextBackupData(text: "ABAM \(CustomFormatter.setWritedate(date: Date()))")
    }
    
    //셀에 들어갈 데이터 즉 스냅샷 + 백업
    private func setTextBackupData(text: String) {
        
        do {
            try saveEncodedDiaryToDocument(tasks: tasks)
            try saveEncodeCheerupToDocument(tasks: cheerupTasks)
            let backupFilePth = try createBackupFile(fileName: text, keyFile: .ABAMKeyFile, imageFile: .imageFile)
            fetchBackupFileList()
            backupView.tableView.reloadData()
            try showActivityViewController(backupFileURL: backupFilePth)
            fetchDocumentZipFile()
        }
        catch {
            backupView.makeToast("압축에 실패하였습니다")
        }
        removeKeyFileDocument(fileName: .ABAMKeyFile)
    }
    
    @objc private func clickRestoreCell() {
        
        let alert = UIAlertController(title: "알림", message: "현재 일기에 덮어씌워집니다. 진행하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { [weak self]_ in
            
            guard let self = self else { return }
            
            guard let path = self.documentDirectoryPath() else {
                print("도큐먼트 위치에 오류가 있습니다.")
                return
            }
            
            if FileManager.default.fileExists(atPath: path.path) {
                
                do {
                    let doucumentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
                    doucumentPicker.delegate = self
                    doucumentPicker.allowsMultipleSelection = false
                    self.present(doucumentPicker, animated: true)
                } catch {
                    print("압축풀기에 실패하였습니다")
                }
            }
            //복구완료 얼럿넣기
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "백업파일 목록"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backupfiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SettingDefaultTableViewCell else { return SettingDefaultTableViewCell()}
        
        cell.subTitle.text =  backupfiles?[indexPath.row]
        cell.contentView.backgroundColor = .systemGray6
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeBackupFileDocument(fileName: (backupfiles?[indexPath.row])!)
            fetchBackupFileList()
            backupView.tableView.reloadData()
        }
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐머트픽커 닫음", #function)
    }
    
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
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
       print("sandboxFileURL=====================", sandboxFileURL)
        
        //여기서 앱의 백업복구 파일과 같은지 비교
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let filename_zip = selectedFileURL.lastPathComponent
            print(filename_zip, "========🚀🚀🚀🚀🚀")
            let temporaryFolder = createFolder(foldername: .unzipFolder)

            let zipfileURL = path.appendingPathComponent(filename_zip)
            let keyFileURL = temporaryFolder.appendingPathComponent(PathComponentName.ABAMKeyFile.rawValue)
            let newzipfileURL = temporaryFolder.appendingPathComponent(filename_zip)
            
            do {
                try FileManager.default.copyItem(at: zipfileURL, to: newzipfileURL)
            } catch {
                print(#function, "🔴copyItem 오류")
            }
            
            do {
                try unzipFile(fileURL: newzipfileURL, documentURL: temporaryFolder)
                do {
                    if FileManager.default.fileExists(atPath: keyFileURL.path) {
                        try FileManager.default.removeItem(at: temporaryFolder)
                        try unzipFile(fileURL: zipfileURL, documentURL: path)
                        
                        //여기서 작세하는 keyfile은 도큐
                        removeKeyFileDocument(fileName: .ABAMKeyFile)
                        OneDayDiaryRepository.shared.deleteTasks(tasks: self.tasks)
                        CheerupMessageRepository.shared.deleteTasks(tasks: self.cheerupTasks)
                        
                        try self.restoreRealmForBackupFile()
                        
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        let sceneDelegate = windowScene?.delegate as? SceneDelegate
                        
                        let transition = CATransition()
                        transition.type = .fade
                        transition.duration = 0.3
                        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
                        
                        sceneDelegate?.window?.rootViewController = TapBarController()
                        sceneDelegate?.window?.makeKeyAndVisible()

                    } else {
                        controller.dismiss(animated: true) {
                            let alert = UIAlertController(title: "복구 알림", message: "아밤일기의 파일이 맞으신가요?ㅠㅠ", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default)
                            self.removeBackupFileDocument(fileName: filename_zip)
                            
                            do {
                                try FileManager.default.removeItem(at: temporaryFolder)
                            } catch {
                                print("FileManager.default.removeItem(at: temporaryFolder🔴🔴")
                            }
                            
                            Analytics.logEvent("notMyBackupFile", parameters: [
                                "name": "not my AppBackupFile",
                            ])
                            
                            alert.addAction(ok)
                            self.present(alert, animated: true)
                        }
                    }
                } catch {
                    Analytics.logEvent("documentRestore", parameters: [
                        "name": "DocfailRestore",
                    ])
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
                let zipfileURL = path.appendingPathComponent(filename_zip)
                let temporaryFolder = createFolder(foldername: .unzipFolder)
                let keyFileURL = temporaryFolder.appendingPathComponent(PathComponentName.ABAMKeyFile.rawValue)
                let newzipfileURL = temporaryFolder.appendingPathComponent(filename_zip)
                
                do {
                    try FileManager.default.copyItem(at: zipfileURL, to: newzipfileURL)
                } catch {
                    print(#function, "🔴copyItem 오류")
                }
                
                do {
                    try unzipFile(fileURL: newzipfileURL, documentURL: temporaryFolder)
                    do {
                        if FileManager.default.fileExists(atPath: keyFileURL.path) {
                            try FileManager.default.removeItem(at: temporaryFolder)
                            try unzipFile(fileURL: zipfileURL, documentURL: path)
                           
                            removeKeyFileDocument(fileName: .ABAMKeyFile)
                            OneDayDiaryRepository.shared.deleteTasks(tasks: self.tasks)
                            CheerupMessageRepository.shared.deleteTasks(tasks: self.cheerupTasks)
                            
                            try self.restoreRealmForBackupFile()
                            
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let sceneDelegate = windowScene?.delegate as? SceneDelegate
                            
                            let transition = CATransition()
                            transition.type = .fade
                            transition.duration = 0.3
                            sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
                            
                            
                            sceneDelegate?.window?.rootViewController = TapBarController()
                            sceneDelegate?.window?.makeKeyAndVisible()
                           
                        } else {
                            controller.dismiss(animated: true) {
                                let alert = UIAlertController(title: "복구 알림", message: "아밤일기의 파일이 맞으신가요?ㅠㅠ", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                                    try! FileManager.default.removeItem(at: temporaryFolder)
                                    Analytics.logEvent("fileAppRestore", parameters: [
                                        "name": "not my AppBackupFile",
                                    ])
                                }
                                alert.addAction(ok)
                                self.removeBackupFileDocument(fileName: filename_zip)
                                self.present(alert, animated: true)
                            }
                        }
                    } catch {
                        Analytics.logEvent("fileAppRestore", parameters: [
                            "name": "failRestore",
                        ])
                        print("복구실패~~~")
                    }
                } catch {
                    print("압축풀기 실패 다 이놈아~~~")
                }
            } catch {
                print("파일앱에서 복사 실패")
            }
        }
    }
}
