//
//  DeviceManager.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//


//MARK: 폰트크기 및 레이아웃 대응 가기
import Foundation
import UIKit
//import DeviceKit

//MARK: 디바이스 해상도 대응 1번째 방법
extension UIScreen {
    
    enum iOS_13_Devide {
        typealias  Resolution = (Int, Int)
    case inches_375_667
        case inches_375_812
        case inches_414_736
        case inches_414_896
        case inches_390_844
        case inches_428_926
        
        var resolution: Resolution {
            switch self {
            case .inches_375_667:
               return (375, 812)
            case .inches_375_812:
                return (375, 812)
            case .inches_414_736:
                return (414, 736)
            case .inches_414_896:
                return (390, 896)
            case .inches_390_844:
                return (390, 844)
            case .inches_428_926:
                return (428, 926)
            }
        }
        
        
    }
    
    
    
    var isLessThan375pt: Bool { self.bounds.size.width < 375 }
    var is375pt: Bool { self.bounds.size.width == 375 }
  var isWiderThan375pt: Bool { self.bounds.size.width > 375 }
}

//MARK: 해상도 대응 2 라이브러리 사용 -> 더 번거로운 느낌
//enum DeviceGroup {
//    case fourInches
//    case fiveInches
//    case xSerices
//
//    var rawValue: [Device] {
//        switch self {
//        case .fourInches:
//            return [.iPhoneSE]
//        case .fiveInches:
//            return [.iPhone6, .iPhone6s, .iPhone7, .iPhone8]
//        case .xSerices:
//            return Device.allXSeriesDevices
//        }
//    }
//}
