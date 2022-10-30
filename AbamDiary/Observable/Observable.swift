//
//  Observable.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

//mvcm으로 데이터 처리
//애니메이션
//애니메이션 바인딩해주는 부분은 튜블로 값 받기

import Foundation

class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
            
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    //바뀔때마다 값을 반영해주는 메서드
    func bind(_ closusre: @escaping (T) -> Void) {
        closusre(value)
        listener = closusre
    }
}

/*
 전체 바
 그 바위에 저녁 바
 두 바 위에 이미지(중간)
 이미지는 저녁바와 같이 움직임
 비율로 cound를 옵저블로 받고 중간에 이미지가 애니메이션으로 움직임(바의 길이를 위치로 받아서 움직이게 하기)
 */

// 전체 바
// 바 위에 저녁
