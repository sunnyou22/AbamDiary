//
//  MorningAndNight.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation
import UIKit

//MARK: 컬러차트
enum MorningAndNight: Int, CaseIterable {
    case morning
    case night
    
    func setsymbolImage(_ imageview: UIImageView) {
        switch self {
        case .morning:
            imageview.image = UIImage(systemName: "sun.max.fill")
        case .night:
            imageview.image = UIImage(systemName: "moon.stars")
        }
    }
    
    var title: String {
        switch self {
        case .morning:
            return "아침"
        case .night:
            return "져녁"
        }
    }
}
