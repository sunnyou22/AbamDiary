//
//  WriteViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit

import RealmSwift
import Toast
import FirebaseAnalytics

enum WriteMode {
    case newDiary
    case modified
}

class WriteViewController: BaseViewController {
    
    var writeView = WriteView()
    var data: Diary?
    var diarytype: MorningAndNight
    var writeMode: WriteMode
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
        self.writeView.textView.delegate = self
        setnavigation()
        //        self.tabBarController?.tabBar.isHidden = true
        textViewDoneBtnMake(text_field: writeView.textView)
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setnavigation() {
        
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
        let cancel = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteDiary))
        
        let fixspacing = UIBarButtonItem.fixedSpace(20)
        navigationItem.rightBarButtonItems = [saveButton, fixspacing, cancel]
        addKeyboardNotifications()
        
        self.navigationController?.navigationBar.tintColor = Color.BaseColorWtihDark.navigationBarItem
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.BaseColorWtihDark.navigationBarItem]
        
        switch writeMode {
        case .newDiary:
            cancel.isEnabled = false
        case .modified:
            cancel.isEnabled = true
        }
        
        guard data?.contents != nil else {
            switch diarytype {
            case .morning:
                navigationItem.title = "아침일기"
                writeView.textView.text =  writeView.setWriteVCPlaceholder(type: diarytype)
            case .night:
                navigationItem.title = "저녁일기"
                writeView.textView.text =  writeView.setWriteVCPlaceholder(type: diarytype)
                return
            }
            return
        }
        
        navigationItem.title = "수정"
        writeView.textView.text = data?.contents
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        
        //데이터 패치
        OneDayDiaryRepository.shared.fetchLatestOrder()
        writeView.dateLabel.text = CustomFormatter.setWritedate(date: data?.createdDate ?? Date())
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    //MARK: - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }
    
    private func textViewDoneBtnMake(text_field : UITextView) {
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.tintColor = Color.BaseColorWtihDark.labelColor
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        ViewForDoneButtonOnKeyboard.items = [flexibleSpace, btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    @objc private func doneBtnFromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        writeView.textView.resignFirstResponder()
    }
    
    
    //MARK: 저장 메서드 - 키보드 내려줌
    @objc private func save() {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.writeView.isUserInteractionEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let task = Diary(type: diarytype.rawValue, contents: writeView.textView.text, selecteddate: selectedDate ?? Date(), createdDate: Date())

      if writeView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || writeView.textView.text == writeView.setWriteVCPlaceholder(type: diarytype) {
         
            if data?.isInvalidated == true {
                return
            }

        } else {
            switch writeMode {
            case .newDiary:
                writeDiary(mode: .newDiary, task: task)
            case .modified:
                if data?.isInvalidated == true {
                    writeDiary(mode: .newDiary, task: task)
                    return
                }
                writeDiary(mode: .modified, task: data!)
            }
        }
        
        writeView.makeToast("\n저장완료!", duration: 0.8, position: .center, title: nil, image: UIImage(named: "ABAM")) { [weak self] didTap in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        writeView.textView.resignFirstResponder()
    }
    
    @objc private func deleteDiary() {

        guard writeView.textView.text != writeView.setWriteVCPlaceholder(type: diarytype), !writeView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            writeView.makeToast("삭제할 데이터가 없습니다!", duration: 0.6, position: .center)
            writeView.textView.text = writeView.setWriteVCPlaceholder(type: diarytype)
            writeView.textView.resignFirstResponder()
            return
        }
            let alert = UIAlertController(title: "일기 삭제", message: "정말 현재 일기를 삭제하시겠습니까?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "네", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                guard let data = self.data else {
                    self.writeView.textView.text = self.writeView.setWriteVCPlaceholder(type: self.diarytype)
                    self.writeView.textView.resignFirstResponder()
                    return
                }
                OneDayDiaryRepository.shared.deleteRecord(item: data)
                self.writeView.textView.text = nil
                self.writeView.textView.text = self.writeView.setWriteVCPlaceholder(type: self.diarytype)
                self.writeView.textView.resignFirstResponder()
                
                self.navigationController?.popViewController(animated: true)
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
        
        Analytics.logEvent("writeDiary", parameters: [
          "name": "\(diarytype)",
          "full_text": "\(#function)",
        ])
        
        // 컬러로 변경하기
        if textView.text == "오늘 아침! 당신의 한줄은 무엇인가요?" || textView.text == "오늘 밤! 당신의 한줄은 무엇인가요?" {
            textView.text = nil
        }
    }
    
    //MARK: 🔴 작성화면 시간 반영이상함 버그
    //데이터 추가 및 수정
    private func writeDiary(mode: WriteMode, task: Diary) {
        switch mode {
        case .newDiary:
            
            OneDayDiaryRepository.shared.addItem(item: task)
     
        case .modified:
            try! OneDayDiaryRepository.shared.localRealm.write {
                task.contents = writeView.textView.text
                task.createdDate = Date()
            }
        }
    }
}

extension WriteViewController {
    //MARK: - 키보드 메서드
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
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
       
    }
}
