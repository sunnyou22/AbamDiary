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
    func fetchSearchMoriningFilter(text: String) -> Results<Diary>
    func fetchSearchNightFilter(text: String) -> Results<Diary>
    func fetchSearchDateFilter(text: String) -> Results<Diary>
    func fetchDate(date: Date) -> Results<Diary>
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
    
    func fetchSearchMoriningFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("mornimgDiary CONTAINS[c] '\(text)")
    }
    
    func fetchSearchNightFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("nightDiary CONTAINS[c] '\(text)")
    }
    
    func fetchSearchDateFilter(text: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("createdDate CONTAINS[c] '\(text)")
    }
    
    func fetchDate(date: Date) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("createdDate >= %@ AND createdDate < %@", date, Date(timeInterval: 86400, since: date)) //NSPredicate 애플이 만들어준 Filter
    }
    
    
    
    func fetchFilterMonth(start: Date, last: Date) -> Results<Diary> {
        
        return localRealm.objects(Diary.self).filter("selecteddate >= %@ AND selecteddate <= %@", start, last)
    }
    
    func deleteRecord(item: Diary) {
        
        do {
            try localRealm.write {
                localRealm.delete(item)
                print(item)
            }
        } catch {
            print("====> Realm deleteRecord Fail")
        }
    }
    
    func deleteTasks(tasks: Results<Diary>) {
        do {
            try localRealm.write {
                localRealm.delete(tasks)
                print("일기 초기화 완료👌")
            }
        } catch {
            print("====> Realm deleteTasks Fail")
        }
    }
    
    func addItem(item: Diary) {
        do {
            try localRealm.write{
                localRealm.add(item)
                print("====> Realm add Succeed")
            }
        } catch {
            print("====> Realm add Fail")
            // 사용자가에게 얼럿띄워주기
        }
    }
    
}
