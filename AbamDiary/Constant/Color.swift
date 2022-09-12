//
//  Color.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import Foundation
import UIKit


struct Color {
    
    struct BaseColorWtihDark {
        static let backgorund = UIColor { systemcolorChange(traitCollection: $0).backgroundColor }
        static let navigationBarItem = UIColor { systemcolorChange(traitCollection: $0).navigationBarItem }
        static let cellTtitle = UIColor { systemcolorChange(traitCollection: $0).cellTitle }
        static func setDiaryInCell(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setDiaryInCell(type: type) }}
        static func setDiaryInCellPlacholder(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setDiaryInCellPlacholder(type: type) }}
        static func setSymbolInCell(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setSymbolInCell(type: type) }}
        static func setCellBackgroundColor(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setCellBackgroundColor(type: type) }
        }
        static func setGage(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setGage(type: type) }}
        static let thineBar = UIColor { systemcolorChange(traitCollection: $0).thineBar }
        static func setCalendarPoint(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setCalendarPoint(type: type) }}
        static let date = UIColor { systemcolorChange(traitCollection: $0).date }
        static let  cheerupMessege = UIColor {
            systemcolorChange(traitCollection: $0).cheerupMessege
        }
   //calendar
        static let calendarTitle = UIColor {
            systemcolorChange(traitCollection: $0).calendarTitle
        }
        
        static private func systemcolorChange(traitCollection: UITraitCollection) -> Theme {
            guard let theme = Theme(rawValue: traitCollection.userInterfaceStyle.rawValue) else { return .anycase}
            
            return theme
        }
    }
}


extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    
}

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
}

enum Theme: Int {
    case anycase
    case lignt
    case dark
    
    var backgroundColor: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#FDFDF9")
        case .lignt:
            return UIColor(hex: "#FDFDF9")
        case .dark:
            return UIColor(hex: "#2B2A25")
        }
    }
    
    var navigationBarItem: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#2B2A25")
        case .lignt:
            return UIColor(hex: "#2B2A25")
        case .dark:
            return UIColor(hex: "#FDFDF9")
        }
    }
    
    var cellTitle: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#2B2A25")
        case .lignt:
            return UIColor(hex: "#2B2A25")
        case .dark:
            return UIColor(hex: "#FDFDF9")
        }
    }

    func setDiaryInCell(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#2B2A25")
            case .night:
                return UIColor(hex: "#B3B3BC")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#2B2A25")
            case .night:
                return UIColor(hex: "#B3B3BC")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#E9E9E5")
            case .night:
                return UIColor(hex: "#CFCFE4")
            }
        }
    }
    //757592
    
    func setDiaryInCellPlacholder(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#D4D0C5")
            case .night:
                return UIColor(hex: "#B3B3BC")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#D4D0C5")
            case .night:
                return UIColor(hex: "#B3B3BC")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#8F8F89")
            case .night:
                return UIColor(hex: "#757592")
            }
        }
    }
    
    func setSymbolInCell(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#FFA800")
            case .night:
                return UIColor(hex: "#FFA800")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#FFA800")
            case .night:
                return UIColor(hex: "#FFA800")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#FF7666")
            case .night:
                return UIColor(hex: "#D3C579")
            }
        }
    }
    
    func setCellBackgroundColor (type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#FFF3D4")
            case .night:
                return UIColor(hex: "#6A7BA8")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#FFF3D4")
            case .night:
                return UIColor(hex: "#6A7BA8")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#565751")
            case .night:
                return UIColor(hex: "#403F5F")
            }
        }
        
    }
    
    func setGage(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#FF3B30", alpha: 0.6)
            case .night:
                return UIColor(hex: "#4D4BCA", alpha: 0.6)
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#FF3B30", alpha: 0.6)
            case .night:
                return UIColor(hex: "#4D4BCA", alpha: 0.6)
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#FF3B30", alpha: 0.6)
            case .night:
                return UIColor(hex: "#5E5BAF", alpha: 0.6)
            }
        }
    }
    
    var thineBar: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#9A8787")
        case .lignt:
            return UIColor(hex: "#9A8787")
        case .dark:
            return UIColor(hex: "#FFE5E5")
        }
    }
    
    func setCalendarPoint(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#FF4E6E")
            case .night:
                return UIColor(hex: "#505E6A")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#FF4E6E")
            case .night:
                return UIColor(hex: "#505E6A")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#FF4E6E")
            case .night:
                return UIColor(hex: "#4D4BCA")
            }
        }
    }
    
    var date: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#000000")
        case .lignt:
            return UIColor(hex: "#000000")
        case .dark:
            return UIColor(hex: "#CECECE")
        }
    }
    
    var cheerupMsgPlaceholder: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#D4D6C8")
        case .lignt:
            return UIColor(hex: "#D4D6C8")
        case .dark:
            return UIColor(hex: "#FFE5E5")
        }
    }
    
    var cheerupMessege: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#1E4D1D")
        case .lignt:
            return UIColor(hex: "#1E4D1D")
        case .dark:
            return UIColor(hex: "#BAC8C3")
        }
    }
    
    var cheerupUnderView: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#DDE4D3")
        case .lignt:
            return UIColor(hex: "#DDE4D3")
        case .dark:
            return .clear
        }
    }
    
    //MARK: 캘린더
    var calendarTitle: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#5F4A37")
        case .lignt:
            return UIColor(hex: "#5F4A37")
        case .dark:
            return UIColor(hex: "#FFFFFF")
        }
    }
}
