//
//  OnboardingViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/10.
//


import UIKit
import SnapKit

enum onboardImgList: String {
    case first
    case second
    case third
    case fourth
    case fifth
}

class OnboardingViewController: UIViewController {

    let mainView = TestView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainView.backgroundColor = UIColor(hex: "#FDF9EF")
        mainView.pageControl(mainView.pageControl)
        mainView.testScrollView.delegate = self
        contentScrollerivew()
        
        mainView.button.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
    }
    
    @objc func skipOnboarding() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
        
        sceneDelegate?.window?.rootViewController = TapBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func contentScrollerivew() {
        let imageList = [mainView.firstImageView, mainView.secondImageView, mainView.thirdImageView, mainView.fourthImageView, mainView.fifthImageView]
        mainView.pageControl.numberOfPages = imageList.count
        for i in 0..<imageList.count {
            let positionX = mainView.testScrollView.frame.width * CGFloat(i)
            imageList[i].frame = CGRect(x: positionX, y: 0, width: mainView.testScrollView.bounds.width + 20, height: mainView.testScrollView.bounds.height)
        }
    }
    
    func selectedPage(currentPage: Int) {
        mainView.pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = scrollView.contentOffset.x / scrollView.frame.size.width
        selectedPage(currentPage: Int(round(size)))
    }
}

final class TestView: BaseView {
    
    let button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .brown
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.setTitle("skip", for: .normal)
        return view
    }()
    
    let testScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(hex: "#FDF9EF")
        view.isPagingEnabled = true
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let pageControl: UIPageControl = {
           let view = UIPageControl()
      
           return view
       }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FDF9EF")
        return view
    }()
    
    let firstImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.first.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let secondImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.second.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let thirdImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.third.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let fourthImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.fourth.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let fifthImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: onboardImgList.fifth.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 0
        view.backgroundColor = UIColor(hex: "#FDF9EF")
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configuration() {
        super.configuration()
        
        [firstImageView, secondImageView, thirdImageView, fourthImageView, fifthImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        
        testScrollView.addSubview(contentView)
        
        [testScrollView, pageControl, button].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        testScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(24)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.84)
            make.top.equalToSuperview()
            
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(5)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func pageControl(_ : UIPageControl) {
           pageControl.numberOfPages = 5
           pageControl.backgroundColor = UIColor(hex: "#FDF9EF")
           pageControl.pageIndicatorTintColor = .black
           pageControl.currentPageIndicatorTintColor = .brown
           pageControl.currentPage = 0
       }
    
}
