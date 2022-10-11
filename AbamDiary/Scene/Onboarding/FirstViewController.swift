//
//  FirstViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/10/10.
//

import Foundation
import UIKit
import SnapKit

fileprivate func setImgInOnboard(name: onboardImgList, to: UIView){
    let img = UIImageView()
    img.image = UIImage(named: name.rawValue)
    
    to.addSubview(img)
    to.backgroundColor = UIColor(hex: "#FDF9EF")
    
    img.snp.makeConstraints { make in
        make.top.equalTo(to.safeAreaLayoutGuide.snp.top)
        make.bottom.equalTo(to.snp.bottom)
        make.center.equalTo(to.snp.center)
    }
}

class FirstViewController: BaseViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgInOnboard(name: .first, to: view)
    }
}


class SecondViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgInOnboard(name: .second, to: view)
    }
}

class ThirdViewController: BaseViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgInOnboard(name: .third, to: view)
    }
}

class FouredViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setImgInOnboard(name: .fourth, to: view)
    }
}

class FifthViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgInOnboard(name: .fifth, to: view)
    }
}

