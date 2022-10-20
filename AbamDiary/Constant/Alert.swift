//
//  Alert.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/20.
//

import UIKit

//Alert 따로 빼주기

final class CustomAlert: UIViewController {

   static let shared = CustomAlert()

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showDefault(title: String, ok: String = "확인", message: String?, cancel: String = "아니오") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default)
        
        alert.addAction(ok)
      
        present(alert, animated: true)
    }
    
    
    func showMessageWithHandler(title: String, message: String, okCompletionHandler handler: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "네", style: .default) { _ in
            guard let handler = handler else { return }
            handler()
        }
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
      
        alert.addAction(ok)
        alert.addAction(cancel)
        
        //UIWindow present keywindow rootview.present -> alert
        DispatchQueue.main.async {
            guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
            
            viewController.present(alert, animated: true)
        }
    }
}
