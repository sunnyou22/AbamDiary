//
//  MonthDiaryModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation
import RealmSwift

protocol OnedayDiaryRepositoryType {
    func fetchLatestOrder() -> Results<Diary> // 기본정렬값
    func fetchOlderOrder() -> Results<Diary>
    func fetchSearchMoriningFilter(text: String) -> Results<Diary>
    func fetchSearchNightFilter(text: String) -> Results<Diary>
    func fetchSearchDateFilter(text: String) -> Results<Diary>
    func fetchDate(date: Date) -> Results<Diary>
    func deleteRecord(item: Diary)
    func addItem(item: Diary)
}

class OneDayDiaryRepository: OnedayDiaryRepositoryType {
  
    private init() { }
    
    static let shared = OneDayDiaryRepository()
    let localRealm = try! Realm()
    
    @discardableResult
    func fetchLatestOrder() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "initialWritedate", ascending: false)
    }
    
    func fetchOlderOrder() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "initialWritedate", ascending: true)
    }
     
    func fetchSearchMoriningFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("mornimgDiary CONTAINS[c] '\(text)")
    }
    
    func fetchSearchNightFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("nightDiary CONTAINS[c] '\(text)")
    }
    
    func fetchSearchDateFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("initialWritedate CONTAINS[c] '\(text)")
    }
    
    func fetchDate(date: Date) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("initialWritedate >= %@ AND initialWritedate < %@", date, Date(timeInterval: 86400, since: date)) //NSPredicate 애플이 만들어준 Filter
    }
    
    func deleteRecord(item: Diary) {
        
        try! localRealm.write({
            localRealm.delete(item)
            print(item)
        })
    }
    
    func addItem(item: Diary) {
        do {
            try localRealm.write({
                localRealm.add(item)
                print("====> Realm add Succeed")
            })
        } catch {
            print("====> Realm add Fail")
        }
    }
 
}
