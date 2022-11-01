//
//  CalendarModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation

import RealmSwift
import FSCalendar

final class CalendarModel {

    var isExpanded: Observable<Bool> = Observable(false)
    
    //인스턴스가 무조건 생성이 먼저돼야 데이터가 들어올 수 잇다.
    var tasks: Observable<Results<Diary>?> = Observable(nil)
    var monthFilterTasks: Observable<Results<Diary>?> = Observable(nil)
    
    var moningTask: Observable<Diary?> = Observable(nil)
    var nightTask: Observable<Diary?> = Observable(nil)
    var diaryList: Observable<[Diary?]?> = Observable([nil])

    let digit: Float = pow(10, 2) // 10의 2제곱
    var progress: Float = 0 // 변수로 빼줘야 동작

    var filterMorningcount: Observable<Int> = Observable(0)
    var filterNightcount: Observable<Int> = Observable(0)
    
    //MARK: 여기서 아침일기 저녁일기 task 생성
    func diaryTypefilterDate(calendar: FSCalendar) {
        
        //mainview.calendar.selectedDate
        let selectedDate = CustomFormatter.setDateFormatter(date: calendar.selectedDate ?? Date())
        // mainview.calendar.today!
        let calendarToday = CustomFormatter.setDateFormatter(date: calendar.today ?? Date())
        let today =  CustomFormatter.setDateFormatter(date: Date())
        //self.dateFilterTask = OneDayDiaryRepository.shared.fetchDate(date: Date())[0] -> 왜 이렇게 하면안됨? 오늘 작성한게 많을수도 있잖아
        
        // 오늘인 캘린더를 띄워서 경우
        if calendar.selectedDate == nil, calendarToday == today  {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.today!, type: 0).first
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.today!, type: 1).first
            // 오늘을 선택한 경우
        } else if calendar.selectedDate != nil, selectedDate == today {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.today!, type: 0).first // nil이 들어올 수 있음
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.today!, type: 1).first
            // 오늘이 아닌 다른 날을 선택한 경우
        } else if calendar.selectedDate != nil, selectedDate != today {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.selectedDate ?? Date(), type: 0).first
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: calendar.selectedDate ?? Date(), type: 1).first
        } else {
            moningTask.value = nil
            nightTask.value = nil
        }
}
    
    func checkCount(zero: (() -> Void), nonzero: (() -> Void)) {
        let changeMorningcount = Float(filterMorningcount.value)
        let changeNightcount =  Float(filterNightcount.value)
     
        guard changeMorningcount != 0.0 || changeNightcount != 0.0 else {
            print("🔴🔴\(changeMorningcount) != 0.0 || \(changeNightcount) != 0.0 가드문 안")
            zero()
            return
        }
        nonzero()
      
    }
    
    func moringCountRatio() -> Float {
        let changeMorningcount = Float(filterMorningcount.value)
        let changeNightcount = Float(filterNightcount.value)
        
        let plus: Float = changeMorningcount + changeNightcount
        let round: Float = round((changeMorningcount / plus) * digit)
        let moringCountRatio: Float = round / digit
        
        return moringCountRatio
    }
    
    func fetchRealm(calendar: FSCalendar) {
        tasks.value = OneDayDiaryRepository.shared.fetchLatestOrder()
        diaryTypefilterDate(calendar: calendar)
        
        //시간잘 맞춰서 해당 달의 날짜가 들어옴
        monthFilterTasks.value = OneDayDiaryRepository.shared.fetchFilterMonth(start: CustomFormatter.isStarDateOfMonth(), last: CustomFormatter.isDateEndOfMonth())
    }
    
    func setProgressRetio(completionHandler: (Float) -> Void) {
       
       let moringCountRatio = self.moringCountRatio()
        
        if moringCountRatio.isNaN {
            progress = 0
        } else {
            progress = moringCountRatio
        }
        
        completionHandler(progress)
      
//        completionHandler에 넣어주기
//        completionHandler()

    }
}
