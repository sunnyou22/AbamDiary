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
    
    func transition<T: UIViewController>(_ vc: T, transitionStyle: TransitionStyle) {
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
}
