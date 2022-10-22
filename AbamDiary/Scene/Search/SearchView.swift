//
//  SearchView.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/14.
//

import Foundation
import UIKit
import SnapKit

final class MyHeaderFooterView: UICollectionReusableView {
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "나는야 헤더"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        
        self.backgroundColor = .gray
        label.snp.makeConstraints { make in
            make.center.equalTo(self.center)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchView: BaseView {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        view.backgroundColor = Color.BaseColorWtihDark.backgorund
        return view
    }()
    
    override func configuration() {
        self.addSubview(collectionView)
        self.backgroundColor = Color.BaseColorWtihDark.backgorund
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(20)
        }
    }
    
    static private func setLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            //item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            //group
            // 그럼 그룹의 높이는 어디에 비율을 걸어주는 건지
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 30
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 60, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "", alignment: .top)
            
            section.boundarySupplementaryItems = [headerSupplementary]
            
//            
//            
//            NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
//                                                                 
//            NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leadingItem, trailingGroup])
            
            
            //                if #available(iOS 16.0, *) {
            //                    section.supplementaryContentInsetsReference = .none
            //                } else {
            //                    // Supplementary View가 section의 contentInsets에 영향을 받지 않도록
            //                    section.supplementariesFollowContentInsets = false
            //                }
            return section
            
        }
    }
    
}



