//
//  PageViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/09.
//OnboadingViewController

import Foundation
import UIKit

final class PageViewController: UIPageViewController {
    
    var pageViewControllerList: [UIViewController] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        createPageViewController()
        configurePageViewController()
    }
    
    func createPageViewController() {
        let first = FirstViewController()
        let second = SecondViewController()
        let thired = ThirdViewController()
        let foured = FouredViewController()
        let fifth = FifthViewController()
        
        pageViewControllerList = [first, second, thired, foured, fifth]
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
  
        guard let first = pageViewControllerList.first else { return } // 배열에 0번 인덱스가 있는지 확인
        
        setViewControllers([first], direction: .forward, animated: true) //
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        print(index, "=====================인덱스 받아오기")
        return index
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
}
