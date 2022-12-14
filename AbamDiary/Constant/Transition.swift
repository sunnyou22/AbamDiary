//
//  Transition.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/13.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    enum TransitionStyle: Int, CaseIterable {
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
}
