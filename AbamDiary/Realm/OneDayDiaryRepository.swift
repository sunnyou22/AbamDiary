//
//  MonthDiaryModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//
import UIKit
import RealmSwift

fileprivate protocol OnedayDiaryRepositoryType {
    func fetchLatestOrder() -> Results<Diary> // 기본정렬값
    func fetchOlderOrder() -> Results<Diary>
    func fetchSearchFilter(text: String?, type: Int) -> Results<Diary>?
    func fetchSearchDateFilter(text: String) -> Results<Diary>
    func fetchDate(date: Date, type: Int) -> Results<Diary>
    func deleteRecord(item: Diary)
    func deleteTasks(tasks: Results<Diary>)
    func addItem(item: Diary)
}

class OneDayDiaryRepository: OnedayDiaryRepositoryType {
    
    private init() { }
    
    static let shared = OneDayDiaryRepository()
    let localRealm = try! Realm()
    
    @discardableResult
    func fetchLatestOrder() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func fetchOlderOrder() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "createdDate", ascending: true)
    }
    
    func fetchSearchFilter(text: String?, type: Int) -> Results<Diary>? {
        guard let text = text else {
            return nil
        }
        let items = localRealm.objects(Diary.self)
           let item2 = items.filter("contents CONTAINS[c] '\(text)")
        let result = items.filter("type == %@", type)
        
        return result
    }
    
    func fetchSearchDateFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("createdDate CONTAINS[c] '\(text)")
    }
    
    func fetchDate(date: Date, type: Int) -> Results<Diary> {
        let item = localRealm.objects(Diary.self).filter("selecteddate >= %@ AND selecteddate < %@", date, Date(timeInterval: 86400, since: date)) //NSPredicate 애플이 만들어준 Filter
        if item.isEmpty {
            return item
        } else {
            let result = item.filter("type == %@", type)
            return result
        }
//        return
    }
    
    
    
    func fetchFilterMonth(start: Date, last: Date) -> Results<Diary> {
        
        return localRealm.objects(Diary.self).filter("selecteddate >= %@ AND selecteddate <= %@", start, last)
    }
    
    func deleteRecord(item: Diary) {
        
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
        }
    }
    
    func deleteTasks(tasks: Results<Diary>) {
        do {
            try localRealm.write {
                localRealm.delete(tasks)
            }
        } catch {
        }
    }
    
    func addItem(item: Diary) {
        do {
            try localRealm.write{
                localRealm.add(item)
            }
        } catch {
            // 사용자가에게 얼럿띄워주기
        }
    }
    
}
