//
//  WriteViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit
import RealmSwift

enum WriteMode {
    case newDiary
    case modified
}

class WriteViewController: BaseViewController {
    
    var writeView = WriteView()
    var data: MainList?
    var viewModel = GageModel()
    var diarytype: MorningAndNight
    
    init(diarytype: MorningAndNight) {
        self.diarytype = diarytype
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.writeView.textView.delegate = self
        
        //데이터 패치
        MainListRepository.shared.fetchLatestOrder()
        
        //뷰에 데이터 반영
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if writeView.textView.text == "오늘 아침! 당신의 한줄은 무엇인가요?" || writeView.textView.text == "오늘 밤! 당신의 한줄은 무엇인가요?" || writeView.textView.text.isEmpty {
            self.navigationController?.popViewController(animated: true)
        } else {
            switch diarytype {
            case .morning:
                data?.mornimgDiary = writeView.textView.text
            case .night:
                data?.nightDiary = writeView.textView.text
            }
        }
        
        
        
        //
        //
        
        //    @objc func save() {
        //        if writeView.textView.text == "오늘 아침! 당신의 한줄은 무엇인가요?" || writeView.textView.text != "오늘 밤! 당신의 한줄은 무엇인가요?" {
        //            let task = MainList(mornimgDiary: writeView.textView.text, nightDiary: writeView.textView.text, cheerupDiary: nil, date: Date())
        //            writeDiary(type: .morning, mode: .newDiary, task: task)
        //        } else {
        //            writeDiary(type: <#T##MorningAndNight#>, mode: <#T##WriteMode#>, task: <#T##MainList#>)
        //        }
        //    }
    }
}

//데이터 넣고 화면반영하기
extension WriteViewController: UITextViewDelegate {
    
    //플레이스 홀더 없애기 생각하기
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("-========", textView.text)
        print("========", writeView.textView.text)
        print(writeView.setWriteVCPlaceholder(type: .morning))
        
        if textView.text == "오늘 아침! 당신의 한줄은 무엇인가요?" || textView.text == "오늘 밤! 당신의 한줄은 무엇인가요?" {
            textView.text = nil
        }
    }
    
    //데이터 추가 및 수정
    func writeDiary(type: MorningAndNight, mode: WriteMode, task: MainList) {
        switch type {
        case .morning:
            switch mode {
            case .newDiary:
                MainListRepository.shared.addItem(item: task)
            case .modified:
                try! MainListRepository.shared.localRealm.write {
                    task.mornimgDiary = writeView.textView.text
                }
            }
        case .night:
            switch mode {
            case .newDiary:
                MainListRepository.shared.addItem(item: task)
            case .modified:
                try! MainListRepository.shared.localRealm.write {
                    task.nightDiary = writeView.textView.text
                }
            }
        }
    }
}
