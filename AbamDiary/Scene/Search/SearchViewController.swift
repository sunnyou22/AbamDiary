//
//  SearchViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit

import RealmSwift

class SearchViewController: BaseViewController, UICollectionViewDelegate {
    
    var searchView = SearchView()
    var diarytype: MorningAndNight?
    
    override func loadView() {
        view = searchView
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tasks: Results<Diary>!
    
    private var cellRegistration: UICollectionView.CellRegistration<SearchCollectionViewCell, Diary>!
    private var dataSource: UICollectionViewDiffableDataSource<MorningAndNight, Diary>!
    
    var filteredArr: Results<Diary>!
    
    var morningFilteredArr: Results<Diary>!
    
    var nightFilteredArr: Results<Diary>!
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    //MARK: 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchView.collectionView.delegate = self
        setupSearchController()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
        
        //0 레이아웃
        
        //1 데이터소스
        configurationDataSource()
        
        //2 어플라이
        configurationView()
        applySnapShot()
    }
    
    private func fetch() {
        tasks = OneDayDiaryRepository.shared.fetchLatestOrder()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "원하는 키워드를 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = title
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = Color.BaseColorWtihDark.backgorund
        navigationItem.scrollEdgeAppearance = barAppearance
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("fsdfsdfs")
        guard let text = searchController.searchBar.text else { return }
        fetch()
        guard let items = tasks else {
            return
        }
        self.morningFilteredArr = items.where { $0.contents.contains(text) && ($0.type == 0) }
        self.nightFilteredArr = items.where { $0.contents.contains(text) && ($0.type == 1) }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    private func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: Diary?) {
            let vc = WriteViewController(diarytype: diaryType, writeMode: mode)
            vc.data = task
            
            switch mode {
                
            case .newDiary:
                transition(vc, transitionStyle: .push)
                switch diaryType {
                case .morning:
                    vc.writeView.setWriteVCPlaceholder(type: .morning)
                case .night:
                    vc.writeView.setWriteVCPlaceholder(type: .night)
                    
                }
            case .modified:
                transition(vc, transitionStyle: .push)
                
            }
        }
    }

extension SearchViewController {
    private func configurationView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .firstItemInSection
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnviroment)
            return section
        }
        searchView.collectionView.collectionViewLayout = layout
    }
    
    private func configurationDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, Diary>  { cell, indexPath, itemIdentifier in
            
            cell.diaryLabel.text = itemIdentifier.contents
            cell.setMornigAndNightConfig(index: indexPath.row)
            cell.dateLabel.text = CustomFormatter.setTime(date: itemIdentifier.createdDate)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<MyHeaderFooterView>(elementKind: "") { supplementarview, ele, indexPath in
            
        }
        
        dataSource.supplementaryViewProvider = { collectionView, ele, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func applySnapShot() {
        
        guard (morningFilteredArr != nil) && (nightFilteredArr != nil) else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.morning, .night])
        snapshot.appendItems(morningFilteredArr.compactMap { $0 }, toSection: .morning)
        snapshot.appendItems(nightFilteredArr.compactMap { $0 }, toSection: .night)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
//
//extension SearchViewController: UICollectionViewDelegate {
//    
//    //학퍼블한테 물어보기
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        guard let morningFilteredArr = self.morningFilteredArr else {
//            return nil
//        }
//        
//        guard let nightFilteredArr = self.nightFilteredArr else {
//            return nil
//        }
//        
//        let currentDiaryDelete = UIAction(title: "해당 일기 삭제") { [weak self] _ in
//            
//            guard let self = self else { return }
//            
//            if indexPaths.first?.section == 0 {
//                let Mitem = morningFilteredArr[indexPaths.first!.row]
//                OneDayDiaryRepository.shared.deleteRecord(item: Mitem)
//            } else if indexPaths.first?.row == 1 {
//                let Nitem = nightFilteredArr[indexPaths.first!.row]
//                OneDayDiaryRepository.shared.deleteRecord(item: Nitem)
//            }
//        }
//        
//        let currdntDiaryModifing = UIAction(title: "수정") { [weak self] _ in
//            
//            guard let self = self else { return }
//            
//            if indexPaths.first?.section == 0 {
//                let Mitem = morningFilteredArr[indexPaths.first!.row]
//                setWritModeAndTransition(.modified, diaryType: .morning, task: Mitem)
//            } else if indexPaths.section == 1 {
//                let Nitem = nightFilteredArr[indexPaths.first!.row]
//                self.setWritModeAndTransition(.modified, diaryType: .morning, task: Nitem)
//            }
//        }
//        
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            UIMenu(title: "", children: [currdntDiaryModifing, currentDiaryDelete])
//        }
//    }
//}
