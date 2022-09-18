//
//  Reusable.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/10.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
    
}

extension UITableViewCell: ReusableViewProtocol {
   static var reuseIdentifier: String {
        return String(describing: self)
    }
}
