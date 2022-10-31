//
//  CalendarModel.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation

import RealmSwift

final class CalendarModel {

    var changeMorningcount: Observable<Float> = Observable(0)
    var changeNightcount: Observable<Float> = Observable(0)
    var isExpanded: Observable<Bool> = Observable(false)
    
    //인스턴스가 무조건 생성이 먼저돼야 데이터가 들어올 수 잇다.
    var tasks: Observable<Results<Diary>?> = Observable(nil)
    var monthFilterTasks: Results<Diary>!
    
    var moningTask: Observable<Diary?> = Observable(nil)
    var nightTask: Observable<Diary?> = Observable(nil)
    var diaryList: Observable<[Diary?]?> = Observable(nil)

    var selectedDate: Observable<Date?> = Observable(nil)
    var calendarToday: Observable<Date> = Observable(Date())
    
    let digit: Float = pow(10, 2) // 10의 2제곱
    var progress: Float = 0 // 변수로 빼줘야 동작
    
    //MARK: 여기서 아침일기 저녁일기 task 생성
    func diaryTypefilterDate() {
        
        //mainview.calendar.selectedDate
        let selectedDate = CustomFormatter.setDateFormatter(date: selectedDate.value ?? Date())
        // mainview.calendar.today!
        let calendarToday = CustomFormatter.setDateFormatter(date: calendarToday.value)
        let today =  CustomFormatter.setDateFormatter(date: Date())
        //self.dateFilterTask = OneDayDiaryRepository.shared.fetchDate(date: Date())[0] -> 왜 이렇게 하면안됨? 오늘 작성한게 많을수도 있잖아
        
        // 오늘인 캘린더를 띄워서 경우
        if self.selectedDate.value == nil, calendarToday == today  {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.calendarToday.value, type: 0).first
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.calendarToday.value, type: 1).first
            // 오늘을 선택한 경우
        } else if self.selectedDate.value != nil, selectedDate == today {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.calendarToday.value, type: 0).first // nil이 들어올 수 있음
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.calendarToday.value, type: 1).first
            // 오늘이 아닌 다른 날을 선택한 경우
        } else if self.selectedDate.value != nil, selectedDate != today {
            moningTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.selectedDate.value ?? Date(), type: 0).first
            nightTask.value = OneDayDiaryRepository.shared.fetchDate(date: self.selectedDate.value ?? Date(), type: 1).first
        } else {
            moningTask.value = nil
            nightTask.value = nil
        }
}
    
    func checkCount(zero: (() -> Void), nonzero: (() -> Void)) {
        guard changeMorningcount.value != 0.0 || changeNightcount.value != 0.0 else {
            zero()
            return
        }
        nonzero()
    }
    
    func moringCountRatio() -> Float {
        let plus: Float = changeMorningcount.value + changeNightcount.value
        let round: Float = round((changeMorningcount.value / plus) * digit)
        let moringCountRatio: Float = round / digit
        
        return moringCountRatio
    }
    
    func fetchRealm() {

        tasks.value = OneDayDiaryRepository.shared.fetchLatestOrder()
        diaryTypefilterDate()
        
        //시간잘 맞춰서 해당 달의 날짜가 들어옴
        monthFilterTasks = OneDayDiaryRepository.shared.fetchFilterMonth(start: CustomFormatter.isStarDateOfMonth(), last: CustomFormatter.isDateEndOfMonth())
    }
    
    //아침일기 개수 계산
 func calculateMornigDiary() {
        let filterMorningcount = monthFilterTasks.filter { task in
            return task.type == 0
        }.count
        
        changeMorningcount.value = Float(filterMorningcount)
//        changeNightcount.value = Float(filterMorningcount)
    }
    
    //저녁일기 개수 계산
  func calculateNightDiary() {
        let filterNightcount = monthFilterTasks.filter { task in
            return task.type == 1
        }.count
        
//        changeMorningcount.value = Float(filterNightcount)
        changeNightcount.value = Float(filterNightcount)
    }
    
   func setProgressRetio() {
        let moringCountRatio: Float = (round((changeMorningcount.value / (changeMorningcount.value + changeNightcount.value)) * digit) / digit)
        
        if moringCountRatio.isNaN {
            progress = 0
        } else {
            progress = moringCountRatio
        }
        
       //mainview.progressBar.setProgress(progress, animated: true)
        //completionHandler에 넣어주기
//        completionHandler()
    }
}
