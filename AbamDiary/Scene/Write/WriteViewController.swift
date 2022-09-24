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
    var selectedDate: Date?
    var keyHeight: CGFloat = 0
    
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
        let cancel = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteDiary))
        
        navigationItem.rightBarButtonItems = [saveButton, cancel]
        addKeyboardNotifications()
        let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
        let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"

        navigationItem.largeTitleDisplayMode = .never
        
        switch diarytype {
        case .morning:
            if (data?.morning == nil) || (data?.morning == morningPlaceholer) {
                navigationItem.title = "아침일기"
            } else {
                navigationItem.title = "수정"
            }
        case .night:
            if (data?.night == nil) || (data?.night ==  nightPlaceholder) {
                navigationItem.title = "저녁일기"
            } else {
                navigationItem.title = "수정"
            }
        }
        
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
            print("=====> 🟠 입력된 문자가 없거나 플레이스홀더랑 같을 때 뒤고가기를 누를 때")
            
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
                    if data?.selecteddate == nil {
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
                    if data?.selecteddate == nil {
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
        
//        fetch!()
        removeKeyboardNotifications()
    }
    
    @objc func save() {
        
        //토스트 커스텀하기
        writeView.makeToast("저장완료!", duration: 1.0, position: .center, title: nil, image: UIImage(named: "ABAM")) { [weak self] didTap in
            self?.navigationController?.popViewController(animated: true)
            //            UIApplication.shared.beginIgnoringInteractionEvents() deprecated됨
            //            self?.navigationItem.leftBarButtonItem?.isEnabled = false
            //            self?.navigationItem.backBarButtonItem?.isEnabled = false
            //하지 않아도 램에 값이 중복저장 안됨 -> 근데 어색함 비동기로 해결해보그...ㅣ
            
            self?.writeView.textView.resignFirstResponder()
        }
        //        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @objc func deleteDiary() {
        let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
        let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"
        let alert = UIAlertController(title: "일기 삭제", message: "정말 현재 일기를 삭제하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            switch self.diarytype {
            case .morning:
                self.writeView.textView.text = morningPlaceholer
                self.writeDiary(type: .morning, mode: .modified, task: self.data!)
                
               
            case .night:
                self.writeView.textView.text = nightPlaceholder
                self.writeDiary(type: .night, mode: .modified, task: self.data!)
                
                
            }
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
present(alert, animated: true)
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
    
    //MARK: 🔴 작성화면 시간 반영이상함 버그
    //데이터 추가 및 수정
    func writeDiary(type: MorningAndNight, mode: WriteMode, task: Diary) {
        switch type {
        case .morning:
            switch mode {
            case .newDiary:
                OneDayDiaryRepository.shared.addItem(item: task)
                
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
                
            case .modified:
                try! OneDayDiaryRepository.shared.localRealm.write {
                    task.night = writeView.textView.text
                    task.nightTime = Date()
                }
            }
        }
    }
}

extension WriteViewController {
    //MARK: - 키보드 메서드
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustKeyboard(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let adjustmentHeight = keyboardFrame.height
        if noti.name == UIResponder.keyboardWillChangeFrameNotification {
            writeView.textView.contentInset.bottom = adjustmentHeight - 80
        } else {
            writeView.textView.contentInset.bottom = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

