//
//  MainModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import RealmSwift
import UIKit
import Foundation
//네이밍컨벤션 화면 특성에 따라 바꿔주기 (Ex: calendarVC ...)
//=>>> Diary, mornimgDiary => morning
//일기 종류별 개수 -> 쿼리 계산 가능
    // 일기종류별 개수가 많아지면 비효율적일수도

class Diary: Object, Codable {
    
    private override init() { }
    
    @Persisted var type: Int
    @Persisted var contents: String?
    @Persisted var selecteddate: Date?
    @Persisted var createdDate = Date()
    @Persisted var time: Date?
    
    // string 추가햅ㄱ
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(type: Int, contents: String?, selecteddate: Date, createdDate: Date, time: Date?) {
        self.init()
        self.objectID = objectID
        self.type = type
        self.contents = contents
        self.selecteddate = selecteddate
        self.createdDate = Date()
        self.time = time
       
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectID, forKey: .objectID)
        try container.encode(type, forKey: .type)
        try container.encode(contents, forKey: .contents)
        try container.encode(selecteddate, forKey: .selecteddate)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(time, forKey: .time)
    }
//
    enum CodingKeys: CodingKey {
        case type
        case contents
        case selecteddate
        case createdDate
        case time
        case objectID
    }
//
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._type = try container.decode(Persisted<Int>.self, forKey: .type)
        self._contents = try container.decode(Persisted<String?>.self, forKey: .contents)
        self._selecteddate = try container.decode(Persisted<Date?>.self, forKey: .selecteddate)
        self._createdDate = try container.decode(Persisted<Date>.self, forKey: .createdDate)
        self._time = try container.decode(Persisted<Date?>.self, forKey: .time)
        self._objectID = try container.decode(Persisted<ObjectId>.self, forKey: .objectID)
    }
}

class CheerupMessage: Object, Codable {
    
    private override init() {
    }
    
    @Persisted var cheerup: String?
    @Persisted var date = Date()
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(cheerup: String, date: Date) {
        self.init()
        self.cheerup = cheerup
        self.date = Date()
    }
    
    enum CondingKeys: String, CodingKey {
        case objectID
        case cheerup
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CondingKeys.self)
        try container.encode(objectID, forKey: .objectID)
        try container.encode(cheerup, forKey: .cheerup)
        try container.encode(date, forKey: .date)
    }
    
    enum CodingKeys: CodingKey {
        case cheerup
        case date
        case objectID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._cheerup = try container.decode(Persisted<String?>.self, forKey: .cheerup)
        self._date = try container.decode(Persisted<Date>.self, forKey: .date)
        self._objectID = try container.decode(Persisted<ObjectId>.self, forKey: .objectID)
    }
}
