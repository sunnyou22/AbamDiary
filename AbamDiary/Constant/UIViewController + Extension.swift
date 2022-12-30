//
//  UIViewController + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/12/31.
//

import UIKit

extension UIViewController {
    //현재 뷰를 취상단뷰로 설정해줌
    var topViewController: UIViewController? {
        return self.topViewController(currtentViewController: self)
    }
    
    func topViewController(currtentViewController: UIViewController) -> UIViewController {
        
        //최상탄 뷰컨이 탭바일때
        if let tabBarController = currtentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currtentViewController: selectedViewController)
            
        } else if let navigationController = currtentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currtentViewController: visibleViewController)
            
        } else if let presentedViewController = currtentViewController.presentedViewController {
            return self.topViewController(currtentViewController: presentedViewController)
            
        } else {
           return currtentViewController
        }
    }
}
