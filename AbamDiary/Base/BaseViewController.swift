//
//  BaseViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit

class BaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setConstraints()
    }
    
    func configuration() { }
    
    func setConstraints() { }
 
    func showOkAlertMessage(title: String, button: String = "확인") {
         let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
         let ok = UIAlertAction(title: button, style: .default)
         alert.addAction(ok)
        
         present(alert, animated: true)
     }
}
