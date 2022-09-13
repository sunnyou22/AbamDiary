//
//  MainModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import RealmSwift
import Foundation

class MainList: Object {
    @Persisted var mornimgDiary: String
    @Persisted var nightDiary: String
    @Persisted var cheerupDiary: String
    @Persisted var date = Date()
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(mornimgDiary: String, nightDiary: String, cheerupDiary: String ,date: Date) {
        self.init()
        self.mornimgDiary = mornimgDiary
        self.nightDiary = nightDiary
    }
}
