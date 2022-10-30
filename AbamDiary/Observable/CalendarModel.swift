//
//  CalendarModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation

class CalendarModel {

    var morningDiaryCount: Observable<Float> = Observable(0)
    var nightDiaryCount: Observable<Float> = Observable(0)
    var isExpanded: Observable<Bool> = Observable(false)
    
}
