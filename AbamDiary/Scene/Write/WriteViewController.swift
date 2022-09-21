//
//  WriteViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast

enum WriteMode {
    case newDiary
    case modified
}

class WriteViewController: BaseViewController {
    
    var writeView = WriteView()
    var data: Diary?
    var diarytype: MorningAndNight
    var writeMode: WriteMode
    var fetch: (() -> Void)?
    var moringCount: (() -> Void)?
    var nightCount: (() -> Void)?
    var selectedDate: Date?
    
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
        OneDayDiaryRepository.shared.fetchLatestOrder()
        
        //뷰에 데이터 반영
        switch diarytype {
        case .morning:
            writeView.dateLabel.text = CustomFormatter.setWritedate(date: (data?.morningTime ?? selectedDate) ?? Date())
        case .night:
            writeView.dateLabel.text = CustomFormatter.setWritedate(date: (data?.morningTime ?? selectedDate) ?? Date())
        }
    
        // 플레이스 홀더
        
        switch diarytype {
        case .morning:
            switch writeMode {
            case .newDiary:
                writeView.setWriteVCPlaceholder(type: .morning)
            case .modified:
                writeView.textView.text = data?.morning
            }
            
        case .night:
            switch writeMode {
            case .newDiary:
                writeView.setWriteVCPlaceholder(type: .night)
            case .modified:
                writeView.textView.text = data?.night
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
        let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"
        
        var task = Diary(morning: writeView.textView.text, night: nil, createdDate: Date(), selecteddate: selectedDate ?? Date(), morningTime: selectedDate ?? Date(), nightTime: nil)
        
        //초기화면
        if writeView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || writeView.textView.text == morningPlaceholer || writeView.textView.text == nightPlaceholder {
            print("=====> 🟠 입력된 문자가 없는데 뒤고가기를 누를 때")
            
            switch diarytype {
            case .morning:
                switch writeMode {
                case .newDiary:
                    writeView.textView.text = morningPlaceholer
                    print("🟠 새로운 작성화면 아침일기")
                case .modified:
                    writeView.textView.text = morningPlaceholer
                    writeDiary(type: .morning, mode: .modified, task: data!)
                    print("🟠 수정 작성화면 아침일기")
                }
            case .night:
                
                switch writeMode {
                case .newDiary:
                    writeView.textView.text = nightPlaceholder
                    print("🟠 새로운 작성화면 저녁일기")
                case .modified:
                    writeView.textView.text = nightPlaceholder
                    writeDiary(type: .morning, mode: .modified, task: data!)
                    print("🟠 수정 작성화면 저녁일기")
                }
            }
        } else {
            switch diarytype {
            case .morning:
                switch writeMode {
                case .newDiary:
                    if data?.createdDate == nil {
                        
                        writeDiary(type: diarytype, mode: .newDiary, task: task)
                    } else {
                        print(data?.createdDate)
                        writeDiary(type: diarytype, mode: .modified, task: data!)
                    }
                case .modified:
                    print("Realm is located at:", OneDayDiaryRepository.shared.localRealm.configuration.fileURL!)
                    writeDiary(type: diarytype, mode: .modified, task: data!)
                    
                }
            case .night:
                task = Diary(morning: nil, night: writeView.textView.text, createdDate: Date(), selecteddate: selectedDate ?? Date(), morningTime: nil, nightTime: selectedDate ?? Date())
                switch writeMode {
                case .newDiary:
                    if data?.createdDate == nil {
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
        
        fetch!()
    }
    
    @objc func save() {
      
        //토스트 커스텀하기
        writeView.makeToast("저장완료!", duration: 2.0, position: .center, title: nil, image: UIImage(named: "ABAM")) { didTap in
            self.navigationController?.popViewController(animated: true)
        }
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
    func writeDiary(type: MorningAndNight, mode: WriteMode, task: Diary) {
        switch type {
        case .morning:
            switch mode {
            case .newDiary:
                OneDayDiaryRepository.shared.addItem(item: task)
                moringCount!()
                print("-====>🟢 아침일기 작성되는 순간")
            case .modified:
                try! OneDayDiaryRepository.shared.localRealm.write {
                    print("-====>🟢 아침일기 수정되는 순간")
                    task.morning = writeView.textView.text
                    task.morningTime = Date()
                    //                    fetch!()
                }
            }
        case .night:
            switch mode {
            case .newDiary:
                OneDayDiaryRepository.shared.addItem(item: task)
               nightCount!()
            case .modified:
                try! OneDayDiaryRepository.shared.localRealm.write {
                    task.night = writeView.textView.text
                    task.nightTime = Date()
                }
            }
        }
    }
}

