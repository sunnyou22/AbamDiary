//
//  CheerupModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/17.
//

import RealmSwift

fileprivate protocol CheerupMessageRepositoryType {
    func fetchDate(ascending: Bool) -> Results<CheerupMessage>
    func deleteRecord(item: CheerupMessage)
    func deleteTasks(tasks: Results<CheerupMessage>)
    func addItem(item: CheerupMessage)
}

class CheerupMessageRepository: CheerupMessageRepositoryType {
    
    private init() { }
    
    static let shared = CheerupMessageRepository()
    let localRealm = try! Realm()
    
    func fetchDate(ascending: Bool) -> Results<CheerupMessage> {
        return localRealm.objects(CheerupMessage.self).sorted(byKeyPath: "date", ascending: ascending)
    }
    
    func deleteRecord(item: CheerupMessage) {
        do {
            try localRealm.write({
                localRealm.delete(item)
            })
            
        } catch let error {
        }
    }
    
    func deleteTasks(tasks: Results<CheerupMessage>) {
        do {
            try localRealm.write {
                localRealm.delete(tasks)
            }
        } catch {
        }
    }
    
    func addItem(item: CheerupMessage) {
        do {
            try localRealm.write({
                localRealm.add(item)
            })
            
        } catch let error {
        }
    }
}
