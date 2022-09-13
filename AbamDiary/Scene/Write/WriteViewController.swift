//
//  WriteViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit

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
    }
}

//데이터 넣고 반영하기
extension WriteViewController {
    
    func writeDiary(type: MorningAndNight, mode: WriteMode, task: MainList) {
        
        switch type {
        case .morning:
            switch mode {
            case .modified:
                // 램 업데이트
            case .newDiary:
                repository.addItem(item: task)
            }
        case .night:
            switch mode {
            case .modified:
                // 램 업데이트
            case .newDiary:
                repository.addItem(item: task)
            }
        }
    }
}
        
//        self.writeView.textView.text = self.writeView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? self.writeView.textView.text : setPlaceholder(type: <#T##MorningAndNight#>)
//    }
//
//    //text에 realm넣어줘야함
//    func setPlaceholder(type: MorningAndNight) -> String {
//        var placeholder: String?
//
//        guard var placeholder = placeholder else { return "일기를 입력해주세요"}
//        switch type {
//        case .morning:
//            placeholder = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
//            return placeholder
//        case .night:
//            placeholder = "오늘 \(type.title)! 당신의 한줄은 무엇인가요?"
//            return placeholder
//        }
//
//        return placeholder
//    }
//}
//
