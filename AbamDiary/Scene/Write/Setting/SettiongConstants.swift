//
//  SettiongConstants.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import Foundation

enum Setting: Int, CaseIterable {
    case notification, backup, reset, other
    
    var sectionTitle: String {
        switch self {
        case .notification:
            return "알림"
        case .backup:
            return "백업"
        case .reset:
            return "초기화"
        case .other:
            return "기타"
        }
    }
    
    var subTitle: [String] {
        let bundle = Bundle.appVersion
        
        switch self {
        case .notification:
            return ["아침 알림 시간", "밤 알림 시간", "알림받기"]
        case .backup:
            return ["백업/복구"]
        case .reset:
            return ["모든일기 삭제하기"]
        case .other:
            return ["오픈라이선스", "문의하기", "리뷰남기기", "버전정보 - \(bundle)"]
        }
    }
}
