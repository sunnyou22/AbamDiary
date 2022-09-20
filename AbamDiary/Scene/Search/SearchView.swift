//
//  SearchView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/14.
//

import Foundation
import UIKit

class SearchView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.reuseIdentifier)
        return view
    }()
    
    override func configuration() {
        self.addSubview(tableView)
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
 
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

