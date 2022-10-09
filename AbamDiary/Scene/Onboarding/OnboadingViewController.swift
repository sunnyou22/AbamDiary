//
//  OnboadingViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/09.
//

import Foundation
import UIKit

final class OnboadingViewController: UIPageViewController {
    
    var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createPageViewController() {
        let first = FirstViewController()
        let second = SecondViewController()
        
        pageViewControllerList = [first, second]
    }
    
    func configurePageViewController() {
//        delegate = self
//        dataSource = self
//        
        guard let first = pageViewControllerList.first else { return } // 배열에 0번 인덱스가 있는지 확인
        setViewControllers([first], direction: .forward, animated: true) //
    }
}

//extension OnboadingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        <#code#>
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        <#code#>
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        <#code#>
//    }
//}
