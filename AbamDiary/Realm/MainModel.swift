//
//  MainModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import RealmSwift
import Foundation

//네이밍컨벤션 화면 특성에 따라 바꿔주기 (Ex: calendarVC ...)
//=>>> Diary, mornimgDiary => morning
//일기 종류별 개수 -> 쿼리 계산 가능
    // 일기종류별 개수가 많아지면 비효율적일수도

class Diary: Object {
    @Persisted var morning: String?
    @Persisted var night: String?
    @Persisted var cheerup: String?
    @Persisted var date = Date()
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(morning: String?, night: String?, cheerup: String? ,date: Date) {
        self.init()
        self.morning = morning
        self.night = night
        self.cheerup = cheerup
        self.date = Date()
    }
}
//self.date = CustomFormatter.setDateFormatter(date: date)
