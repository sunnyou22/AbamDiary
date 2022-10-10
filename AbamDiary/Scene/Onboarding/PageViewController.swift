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
    let pageControl = UIPageControl()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        createPageViewController()
        configurePageViewController()
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = pageViewControllerList.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4
        ).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      
        // set the pageControl.currentPage to the index of the current viewController in pages
            if let viewControllers = pageViewController.viewControllers {
                if let viewControllerIndex = pageViewControllerList.firstIndex(of: viewControllers[0]) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
    }
}
