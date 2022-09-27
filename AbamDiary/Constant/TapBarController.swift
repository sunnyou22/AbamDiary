//
//  TapBarController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/26.
//

import Foundation
import UIKit

final class TapBarController: UITabBarController {
    
    private let mainVC = CalendarViewController()
    private let searchVC = SearchViewController()
   
 //        let monthVC = UINavigationController(rootViewController: MonthDiaryViewController())
    private let cheerupVC = CheerupViewController()
    private let settingVC = SettiongViewController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setAppearance()
    }
    
    private func configure() {
        
        let navMainVC = UINavigationController(rootViewController: mainVC)
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        let navCheerupVC = UINavigationController(rootViewController: cheerupVC)
        let navSettingVC = UINavigationController(rootViewController: settingVC)
        
        setViewControllers([navMainVC, navSearchVC, navCheerupVC, navSettingVC], animated: true)
        
        if let items = tabBar.items {
            for i in 0...(items.count - 1) {
                
                items[i].selectedImage = UIImage(systemName: "lock.open.fill")
                
                items[i].image = UIImage(systemName: TabBarImage.allCases[i].systemImage)
                items[i].title = TabBarImage.allCases[i].tapBarSubTitle
                
            }
            navMainVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            navSearchVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            navCheerupVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            navSettingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
        
      
    }
    
    private func setAppearance() {
        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = Color.BaseColorWtihDark.backgorund
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "#704F3E", alpha: 0.4)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor(hex: "#704F3E", alpha: 0.4)]
//        tabBar.scrollEdgeAppearance = appearance // 이게 가만히
        
//        tabBar.standardAppearance = appearance //이게 움직
//        tabBar.standardAppearance.stackedLayoutAppearance.normal.iconColor = .black
        tabBar.tintColor = Color.BaseColorWtihDark.tapBarTint
//        tabBar.
        
    }
}
