//
//  MainModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import RealmSwift
import UIKit

//네이밍컨벤션 화면 특성에 따라 바꿔주기 (Ex: calendarVC ...)
//=>>> Diary, mornimgDiary => morning
//일기 종류별 개수 -> 쿼리 계산 가능
    // 일기종류별 개수가 많아지면 비효율적일수도

class Diary: Object {
    @Persisted var morning: String?
    @Persisted var night: String?
    @Persisted var selecteddate: Date?
    @Persisted var createdDate = Date()
    @Persisted var morningTime: Date?
    @Persisted var nightTime: Date?
    
    // string 추가햅ㄱ
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(morning: String?, night: String?, createdDate: Date, selecteddate: Date, morningTime: Date?, nightTime: Date?) {
        self.init()
        self.morning = morning
        self.night = night
        self.createdDate = Date()
        self.selecteddate = selecteddate
        self.morningTime = morningTime
        self.nightTime = nightTime
    }
}

class CheerupMessage: Object {
    @Persisted var cheerup: String?
    @Persisted var date = Date()
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(cheerup: String, date: Date) {
        self.init()
        self.cheerup = cheerup
        self.date = Date()
    }
}
//self.date = CustomFormatter.setDateFormatter(date: date)
