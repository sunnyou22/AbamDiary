//
//  Formatter.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation

class CustomFormatter {
    
   static let ko = Locale(identifier:"ko_KR")
    
    //넘버포맷터
   static func setNumberFormat(for number: Int) -> String {
        let numberFornat = NumberFormatter()
        numberFornat.numberStyle = .decimal
        return numberFornat.string(for: number)!
    }
    
    //MARK: - 데이트포맷터
    
    //시간 24시간 형태
    static func setTime(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = CustomFormatter.ko
        timeFormatter.dateFormat = "kk:mm"
        
       return timeFormatter.string(from: date)
    }
    
    //full 날짜 & 시간
    static func setFullFormatter(date: Date) -> String {
        let fullFormatter = DateFormatter()
        
        fullFormatter.dateFormat = "yy.MM.dd a kk:mm"
        
        return fullFormatter.string(from: date)
    }
    
    //날짜
    static func setDateFormatter(date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = CustomFormatter.ko
        dateFormatter.dateFormat = "yyyy. MM. dd "
        
        return dateFormatter.string(from: date)
    }
}
