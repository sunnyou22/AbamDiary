//
//  Transition.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case push
        case presentFullScreen
        case presentFullNavigation
    }
    
    func transition(_ vc: UIViewController, transitionStyle: TransitionStyle) {
        switch transitionStyle {
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        case .presentFullScreen:
            present(vc, animated: true)
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight) {
        let vc = WriteViewController()
        
        switch mode {
        case .modified:
            transition(vc, transitionStyle: .push)
            vc.navigationItem.title = "수정"
        case .newDiary:
            transition(vc, transitionStyle: .push)
            switch diaryType {
            case .morning:
                vc.navigationItem.title = "아침일기"
            case .night:
                vc.navigationItem.title = "저녁일기"
            }
            
        }
        
    }
}
