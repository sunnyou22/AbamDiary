//
//  GageModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation

class GageModel {

    var morningDiaryCount: Observable<Float> = Observable(0)
    var nightDiaryCount: Observable<Float> = Observable(0)

    func saveDiarysCount(completion: @escaping () -> Void) {
        UserDefaults.standard.set(morningDiaryCount.value, forKey: "morningDiaryCount")
        UserDefaults.standard.set(nightDiaryCount.value, forKey: "nightDiaryCount")
        
        completion()
    }
}
