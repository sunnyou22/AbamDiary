//
//  CheerupModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/17.
//

import RealmSwift

fileprivate protocol CheerupMessageRepositoryType {
    func fetchDate() -> Results<CheerupMessage>
    func deleteRecord(item: CheerupMessage)
    func deleteTasks(tasks: Results<CheerupMessage>)
    func addItem(item: CheerupMessage)
}

class CheerupMessageRepository: CheerupMessageRepositoryType {
    
    private init() { }
    
    static let shared = CheerupMessageRepository()
    let localRealm = try! Realm()
    
    func fetchDate() -> RealmSwift.Results<CheerupMessage> {
        return localRealm.objects(CheerupMessage.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    func deleteRecord(item: CheerupMessage) {
        do {
            try localRealm.write({
                localRealm.delete(item)
                print("===> 삭제된 응원메세지", item)
            })
            
        } catch let error {
            print("응원메세지 삭제 오류", error)
        }
    }
    
    func deleteTasks(tasks: Results<CheerupMessage>) {
        do {
            try localRealm.write {
                localRealm.delete(tasks)
                print("일기 초기화 완료👌")
            }
        } catch {
            print("====> Realm deleteTasks Fail")
        }
    }
    
    func addItem(item: CheerupMessage) {
        do {
            try localRealm.write({
                localRealm.add(item)
                print("===> 추가된 응원메세지", item)
            })
            
        } catch let error {
            print("응원메세지 추가 오류", error)
        }
    }
}
