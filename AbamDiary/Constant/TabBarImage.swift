//
//  Image.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import Foundation

enum TabBarImage: Int, CaseIterable {
    case houseFill
    case magnifyingglass
    case magazineFill
    case heartTextSquareFill
    case gearshapeFill
    
    var systemImage: String {
        switch self {
        case .houseFill:
          return "house.fill"
        case .magnifyingglass:
            return "magnifyingglass"
        case .magazineFill:
            return "magazine.fill"
        case .heartTextSquareFill:
            return "heart.text.square.fill"
        case .gearshapeFill:
            return "gearshape.fill"
        }
    }

    var tapBarSubTitle: String {
        switch self {
        case .houseFill:
           return "홈"
        case .magnifyingglass:
            return "검색"
        case .magazineFill:
            return "한달일기"
        case .heartTextSquareFill:
            return "응원"
        case .gearshapeFill:
            return "설정"
        }
    }
}
