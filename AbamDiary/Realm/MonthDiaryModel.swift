//
//  MonthDiaryModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation
import RealmSwift

protocol MainRepositoryType {
    func fetchLatestOrder() -> Results<MainList> // 기본정렬값
    func fetchOlderOrder() -> Results<MainList>
    func fetchSearchMoriningFilter(text: String) -> Results<MainList>
    func fetchSearchNightFilter(text: String) -> Results<MainList>
    func fetchDateFilter(text: String) -> Results<MainList>
    func deleteRecord(item: MainList)
    func addItem(item: MainList)
}

class MainListRepository: MainRepositoryType {
    
    static let shared = MainListRepository()
    let localRealm = try! Realm()
    
    @discardableResult
    func fetchLatestOrder() -> Results<MainList> {
        return localRealm.objects(MainList.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func fetchOlderOrder() -> Results<MainList> {
        return localRealm.objects(MainList.self).sorted(byKeyPath: "date", ascending: true)
    }
     
    func fetchSearchMoriningFilter(text: String) -> Results<MainList> {
        return localRealm.objects(MainList.self).filter("mornimgDiary CONTAINS[c] '\(text)")
    }
    
    func fetchSearchNightFilter(text: String) -> Results<MainList> {
        return localRealm.objects(MainList.self).filter("nightDiary CONTAINS[c] '\(text)")
    }
    
    func fetchDateFilter(text: String) -> Results<MainList> {
        return localRealm.objects(MainList.self).filter("date CONTAINS[c] '\(text)")
    }
    
    func deleteRecord(item: MainList) {

        try! localRealm.write({
            localRealm.delete(item)
            print(item)
        })
    }
    
    func addItem(item: MainList) {
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
