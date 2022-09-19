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
    static func setAMPM(date: Date) -> String {
        let fullFormatter = DateFormatter()
        fullFormatter.locale = CustomFormatter.ko
        fullFormatter.dateFormat = "a"
        
        return fullFormatter.string(from: date)
    }
    
    //날짜
    static func setDateFormatter(date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = CustomFormatter.ko
        dateFormatter.dateFormat = "yyyy. MM. dd "
        
        return dateFormatter.string(from: date)
    }
    
    static func setCheerupDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = CustomFormatter.ko
        dateFormatter.dateFormat = "yy.MM.dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func setCellTitleDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = CustomFormatter.ko
        dateFormatter.dateFormat = "M월의 아밤, dd번째"
        
        return dateFormatter.string(from: date)
    }
    
    static func setWritedate(date: Date) -> String {
        
        let ampm = setAMPM(date: date) == "오전" ? "AM " : "PM "
        return setDateFormatter(date: date) + ampm + setTime(date: date)
    }
    
//    이렇게 모델로 빼줘서 적용하면 시간이 제대로 적용이 안됨
    static func datePicker(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        formatter.dateFormat = "hh:mm"

       return formatter.string(from: date)

    }
}
