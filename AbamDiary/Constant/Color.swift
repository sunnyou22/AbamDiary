//
//  Color.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit
        
struct Color {
    
    private init() { }
    
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
        
        static let tapBarTint = UIColor { systemcolorChange(traitCollection: $0).tapBarTint }
        
        static func setCalendarPoint(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).setCalendarPoint(type: type) }}
        
        static let date = UIColor { systemcolorChange(traitCollection: $0).date }
        
        static let cheerupMessege = UIColor {
            systemcolorChange(traitCollection: $0).cheerupMessege
        }
        
        static let cheerupMsgPlaceholder = UIColor {
            systemcolorChange(traitCollection: $0).cheerupMsgPlaceholder
        }
        
        static let cheerupUnderView = UIColor {
            systemcolorChange(traitCollection: $0).cheerupUnderView
        }
        
        static let progressBarPoint = UIColor {
            systemcolorChange(traitCollection: $0).progressBarPoint
        }
        
        static let messageCount = UIColor {
            systemcolorChange(traitCollection: $0).messageCount
        }
        
   //calendar
        static let calendarTitle = UIColor {
            systemcolorChange(traitCollection: $0).calendarTitle
        }
        
        static let labelColor = UIColor {
            systemcolorChange(traitCollection: $0).labelColor
        }
        
        
        static let setABAMBackground = UIColor {
            systemcolorChange(traitCollection: $0).ABAM
        }
        
        static let alarmButtonBorder = UIColor {
            systemcolorChange(traitCollection: $0).alarmButtonBorder
        }
        
        static let alarmBackgroundBorder = UIColor {
            systemcolorChange(traitCollection: $0).alarmBackgroundBorder
        }
        
        static let calendarToday = UIColor {
            systemcolorChange(traitCollection: $0).calendarToday
        }
        
        static let calendarSelectedDay = UIColor {
            systemcolorChange(traitCollection: $0).calendarSelectedDay
        }
        
        static func popupViewLabel(type: MorningAndNight) -> UIColor {
            UIColor { systemcolorChange(traitCollection: $0).popupViewLabel(type: type) }}
        
        
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
            return UIColor(hex: "#494238")
        case .lignt:
            return UIColor(hex: "#494238")
        case .dark:
            return UIColor(hex: "#E9E1E1")
        }
    }

    func setDiaryInCell(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#2B2A25")
            case .night:
                return UIColor(hex: "#D6D6FD")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#2B2A25")
            case .night:
                return UIColor(hex: "#D6D6FD")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#E9E9E5")
            case .night:
                return UIColor(hex: "#FFFFFF")
            }
        }
    }
    //757592
    
    func setDiaryInCellPlacholder(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#B5AD97")
            case .night:
                return UIColor(hex: "#B3B3BC")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#B5AD97")
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
            return UIColor(hex: "#E1C4C4")
        }
    }
   
    var tapBarTint: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#885A43")
        case .lignt:
            return UIColor(hex: "#885A43")
        case .dark:
            return UIColor(hex: "#67D8B6")
        }
    }
    
    func setCalendarPoint(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return .systemRed
            case .night:
                return UIColor(hex: "#505E6A")
            }
        case .lignt:
            switch type {
            case .morning:
                return .systemRed
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
    
    var progressBarPoint: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#FACB51")
        case .lignt:
            return UIColor(hex: "#FACB51")
        case .dark:
            return UIColor(hex: "#FF6767")
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
            return UIColor(hex: "#FFDADA")
        }
    }
    
    var cheerupUnderView: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#DDE4D3")
        case .lignt:
            return UIColor(hex: "#DDE4D3")
        case .dark:
            return UIColor(hex: "#363636")
        }
    }
    
    var messageCount: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#016E8F")
        case .lignt:
            return UIColor(hex: "#016E8F")
        case .dark:
            return UIColor(hex: "5FFFFF")
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
    
    var calendarToday: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#9D6735")
        case .lignt:
            return UIColor(hex: "#9D6735")
        case .dark:
            return UIColor(hex: "#A0632B", alpha: 0.6)
        }
    }
    
    var calendarSelectedDay: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#9D6735", alpha: 0.6)
        case .lignt:
            return UIColor(hex: "#9D6735", alpha: 0.6)
        case .dark:
            return UIColor(hex: "#A0632B")
        }
    }
    
    var labelColor: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#52402B")
        case .lignt:
            return UIColor(hex: "#52402B")
        case .dark:
            return UIColor(hex: "#E9DDDD")
        }
    }
    
    var ABAM: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#9BA50E")
        case .lignt:
            return UIColor(hex: "#9BA50E")
        case .dark:
            return UIColor(hex: "#00FFB2")
        }
    }
    
    var alarmButtonBorder: UIColor {
        switch self {
        case .anycase:
            return .clear
        case .lignt:
            return .clear
        case .dark:
            return UIColor(hex: "#47675E")
        }
    }
    
    var alarmBackgroundBorder: UIColor {
        switch self {
        case .anycase:
            return UIColor(hex: "#9A8787")
        case .lignt:
            return UIColor(hex: "#9A8787")
        case .dark:
            return Color.BaseColorWtihDark.backgorund
        }
    }
    
    func popupViewLabel(type: MorningAndNight) -> UIColor {
        switch self {
        case .anycase:
            switch type {
            case .morning:
                return UIColor(hex: "#FF9F0F")
            case .night:
                return UIColor(hex: "#6A7BA8")
            }
        case .lignt:
            switch type {
            case .morning:
                return UIColor(hex: "#FF9F0F")
            case .night:
                return UIColor(hex: "#6A7BA8")
            }
        case .dark:
            switch type {
            case .morning:
                return UIColor(hex: "#FF9F0F")
            case .night:
                return UIColor(hex: "#6A7BA8")
            }
        }
    }
}
