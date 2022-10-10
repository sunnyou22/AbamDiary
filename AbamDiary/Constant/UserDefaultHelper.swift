//
//  UserDefaultHelper.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation
    
    class UserDefaultHelper {
        private init() { } // 외부사용 막고
        
        static let shared = UserDefaultHelper()
        
        enum Key: String {
            case morningDiaryCount
            case nightDiaryCount
            case morningNotiPush
            case nightNotiPush
            case initialUser
        }
        
        let userDefaults = UserDefaults.standard
        
        var morningDiaryCount: String {
            get {
                return userDefaults.string(forKey: Key.morningDiaryCount.rawValue) ?? "0"
            }
            set {
                userDefaults.set(newValue, forKey: Key.morningDiaryCount.rawValue)
            }
        }
        
        var nightDiaryCount: String {
            get  {
                return userDefaults.string(forKey: Key.nightDiaryCount.rawValue) ?? "0"
            }
            set  {
                userDefaults.set(newValue, forKey: Key.nightDiaryCount.rawValue)
            }
}
        var initialUser: Bool {
            get  {
                return userDefaults.bool(forKey: Key.initialUser.rawValue)
            }
            set  {
                userDefaults.set(newValue, forKey: Key.initialUser.rawValue)
            }
}
        
    }
