//
//  SceneDelegate.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        //MARK: 탭바
        
        let mainVC = UINavigationController(rootViewController: CalendarViewController.shared)
        let searchVC = UINavigationController(rootViewController: SearchViewController())
//        let monthVC = UINavigationController(rootViewController: MonthDiaryViewController())
        let cheerupVC = UINavigationController(rootViewController: CheerupViewController())
        let settingVC = UINavigationController(rootViewController: SettiongViewController())
        
        let tabBarController = UITabBarController()
        
        tabBarController.setViewControllers([mainVC, searchVC, cheerupVC, settingVC], animated: true)
        
        if let items = tabBarController.tabBar.items {
            for i in 0...(items.count - 1) {
                items[i].selectedImage = UIImage(systemName: "lock.open.fill")
                items[i].image = UIImage(systemName: TabBarImage.allCases[i].systemImage)
                items[i].title = TabBarImage.allCases[i].tapBarSubTitle
                
            }
        }
        
        
        //            if UserDefaultHelper.shared.First {
        //               let vc = CalendarViewController()
        //                guard let vc = sb.instantiateViewController(withIdentifier: IntroViewController.reuseIdentifier) as? IntroViewController else { return }
        //
        //                window?.rootViewController = UINavigationController(rootViewController: vc)
        //            } else {
        //
        //                guard let vc = sb.instantiateViewController(withIdentifier: SearchViewController.reuseIdentifier) as? SearchViewController else { return }
        //
        //                window?.rootViewController = UINavigationController(rootViewController: vc)
        //            }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

