//
//  SearchView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/14.
//

import Foundation
import UIKit
import SnapKit

class SearchView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        view.separatorStyle = .singleLine
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    override func configuration() {
        self.addSubview(tableView)
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
 
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(20)
        }
    }
}

