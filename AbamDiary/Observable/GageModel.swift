//
//  GageModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation

class GageModel {

    var diaryTextView: Observable<String> = Observable("")

    var morningDiaryCount: Observable<Float> = Observable(0)
    var nightDiaryCount: Observable<Float> = Observable(0)

    // 사용자가 중간에 백업하고 일기를 삭제하는 경우에 Count는 남아있어야함(고민)
    func saveDiarysCount(completion: @escaping () -> Void) {
        UserDefaults.standard.set(morningDiaryCount.value, forKey: "morningDiaryCount")
        UserDefaults.standard.set(nightDiaryCount.value, forKey: "nightDiaryCount")
        
        completion()
    }
}
