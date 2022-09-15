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
    var viewModel = DateModel()
    var diarytype: MorningAndNight
    var writeMode: WriteMode
    var fetch: (() -> Void)?
    
    init(diarytype: MorningAndNight, writeMode: WriteMode) {
        self.diarytype = diarytype
        self.writeMode = writeMode
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
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.writeView.textView.delegate = self
        
        //데이터 패치
        MainListRepository.shared.fetchLatestOrder()
        
        //뷰에 데이터 반영
        writeView.dateLabel.text = CustomFormatter.setFullFormatter(date: data?.date ?? Date())
        
        // 플레이스 홀더
        
        switch diarytype {
        case .morning:
            switch writeMode {
            case .newDiary:
                writeView.setWriteVCPlaceholder(type: .morning)
            case .modified:
                writeView.textView.text = data?.mornimgDiary
            }
            
        case .night:
            switch writeMode {
            case .newDiary:
                writeView.setWriteVCPlaceholder(type: .night)
            case .modified:
                writeView.textView.text = data?.nightDiary
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
        let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"
        
        var task = MainList(mornimgDiary: writeView.textView.text, nightDiary: nil, cheerupDiary: nil, date: Date())
        
        //초기화면
        if writeView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("=====> 🟠 입력된 문자가 없는데 뒤고가기를 누를 때")
            switch diarytype {
            case .morning:
                if writeView.textView.text == morningPlaceholer {
                    writeView.textView.text = morningPlaceholer
                }
                
            case .night:
                if writeView.textView.text == nightPlaceholder {
                    writeView.textView.text = nightPlaceholder
                }
            }
        } else {
            switch diarytype {
            case .morning:
                switch writeMode {
                case .newDiary:
                    if data?.date == nil {
                        
                        writeDiary(type: diarytype, mode: .newDiary, task: task)
                        
                    } else {
                        writeDiary(type: diarytype, mode: .modified, task: data!)
                        
                    }
                case .modified:
                    print("Realm is located at:", MainListRepository.shared.localRealm.configuration.fileURL!)
                    writeDiary(type: diarytype, mode: .modified, task: data!)
                    
                }
            case .night:
                task = MainList(mornimgDiary: nil, nightDiary: writeView.textView.text, cheerupDiary: nil, date: Date())
                switch writeMode {
                case .newDiary:
                    if data?.date == nil {
                        
                        writeDiary(type: diarytype, mode: .newDiary, task: task)
                        
                        
                    } else {
                        writeDiary(type: diarytype, mode: .modified, task: data!)
                    }
                case .modified:
                    writeDiary(type: diarytype, mode: .modified, task: data!)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch writeMode {
        case .newDiary:
            switch diarytype {
            case .morning:
                viewModel.morningDiaryteDate.value = Date()
                print("아침 새 일기 작성 날짜 변경")
            case .night:
                viewModel.nightDiaryDate.value = Date()
                print("저녁 새 일기 작성 날짜 변경")
            }
        case .modified:
            switch diarytype {
            case .morning:
                viewModel.morningDiaryteDate.value = Date()
                print("아침 수정 일기 작성 날짜 변경")
            case .night:
                viewModel.nightDiaryDate.value = Date()
                print("저녁 수정 일기 작성 날짜 변경")
            }
        }
        
        print("아침: \(viewModel.morningDiaryteDate.value ), 저녁: \(viewModel.nightDiaryDate.value )")
        
        fetch!()
    }
    
    @objc func save() {
        switch writeMode {
        case .newDiary:
            switch diarytype {
            case .morning:
                viewModel.morningDiaryteDate.value = Date()
            case .night:
                viewModel.nightDiaryDate.value = Date()
            }
            
            case .modified:
            switch diarytype {
            case .morning:
                print("수정 아침 날짜 변경")
                viewModel.morningDiaryteDate.value = Date()
            case .night:
                print("수정 저녁 날짜 변경")
                viewModel.nightDiaryDate.value = Date()
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    //아마 플레이스 홀더가 겹쳐질거임 -> 처리해주기
    override func configuration() {
        
    }
}

//데이터 넣고 화면반영하기
extension WriteViewController: UITextViewDelegate {
    
    //플레이스 홀더 없애기 생각하기
    func textViewDidBeginEditing(_ textView: UITextView) {
        
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
                //                fetch!()
                print("-====>🟢 아침일기 작성되는 순간")
            case .modified:
                try! MainListRepository.shared.localRealm.write {
                    print("-====>🟢 아침일기 수정되는 순간")
                    task.mornimgDiary = writeView.textView.text
                    task.date = Date()
                    //                    fetch!()
                }
            }
        case .night:
            switch mode {
            case .newDiary:
                MainListRepository.shared.addItem(item: task)
                //                fetch!()
            case .modified:
                try! MainListRepository.shared.localRealm.write {
                    task.nightDiary = writeView.textView.text
                    task.date = Date()
                }
            }
        }
    }
}

