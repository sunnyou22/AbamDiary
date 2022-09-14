//
//  WriteViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit
import RealmSwift

enum WriteMode {
    case modified
    case newDiary
}

class WriteViewController: BaseViewController {
    
    var writeView = WriteView()
    var repository = MainListRepository()
    
    var data: MainList?

    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //데이터 패치
        repository.fetchLatestOrder()
        
        //뷰에 데이터 반영
        
    }
}

//데이터 넣고 화면반영하기
extension WriteViewController {
    
    //데이터 추가 및 수정
    func writeDiary(type: MorningAndNight, mode: WriteMode, task: MainList) {
        switch type {
        case .morning:
            switch mode {
            case .modified:
               try! repository.localRealm.write {
                    task.mornimgDiary = writeView.textView.text
                }
            case .newDiary:
                repository.addItem(item: task)
            }
        case .night:
            switch mode {
            case .modified:
               try! repository.localRealm.write {
                    task.nightDiary = writeView.textView.text
                }
            case .newDiary:
                repository.addItem(item: task)
            }
        }
    }

    func fetchDiary(type: MainRepositoryType) {
        
    }
}
