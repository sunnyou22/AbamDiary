//
//  SearchViewController.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/11.
//

import UIKit

import RealmSwift

class SearchViewController: BaseViewController {
    
    var searchView = SearchView()
    var diarytype: MorningAndNight?
    
    override func loadView() {
        view = searchView
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tasks: Results<Diary>! {
        didSet {
            searchView.tableView.reloadData()
            print("서치테이블뷰 리로리로등~♻️")
        }
    }
    
    var filteredArr: Results<Diary>! {
        didSet {
            searchView.tableView.reloadData()
            print("서치테이블뷰 아침필터 tasks ~♻️ 리로등")
        }
    }
    
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
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        setupSearchController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    func fetch() {
        tasks = OneDayDiaryRepository.shared.fetchOlderOrder()
    }
    
    func setupSearchController() {
        searchController.searchBar.placeholder = "원하는 키워드를 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.title = title
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "아침일기" : "저녁일기"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let filteredArr = filteredArr else {
            print("====> 검색어를 찾을 수 없습니다", #function)
            return 0
        }
        
        if section == 0 {
            return filteredArr.filter { $0.type == section }.count
            
        } else if section == 1 {
            return filteredArr.filter { $0.type == section }.count
            }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        guard let filteredArr = filteredArr else {
            print("====> filteredArr이 nil 입니다", #function)
            return UITableViewCell()
        }
        print(filteredArr)
        if self.isFiltering {
            
           if indexPath.section == 0 {
               let item = filteredArr.filter { return $0.type == 0 }
               print(item, "=====================indexPath.section == 0")
                cell.diaryLabel.text = item[indexPath.row].contents
                cell.dateLabel.text = CustomFormatter.setTime(date: item[indexPath.row].createdDate)
           } else if indexPath.section == 1 {
              
               let item = filteredArr.filter { return $0.type == indexPath.section }
               print(item, "=====================indexPath.section == 1")
               cell.diaryLabel.text = item[indexPath.row].contents
               cell.dateLabel.text = CustomFormatter.setTime(date: item[indexPath.row].createdDate)
           }
            
            guard let text = searchController.searchBar.text else { return UITableViewCell() }
            cell.setMornigAndNightConfig(index: indexPath.section)
                let attributedString = NSMutableAttributedString(string: cell.diaryLabel.text ?? "test")
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.diaryLabel.text! as NSString).range(of: "\(text)"))
                cell.diaryLabel.attributedText = attributedString
            }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let currentDiaryDelete = UIAction(title: "해당 일기 삭제") { [weak self] _ in
            
            guard let self = self else { return }
            
            let item = self.filteredArr.filter { $0.type == indexPath.section }
            OneDayDiaryRepository.shared.deleteRecord(item: item[indexPath.row])
            self.searchView.tableView.reloadData()
        }
        
        let currdntDiaryModifing = UIAction(title: "수정") { [weak self] _ in
            
            guard let self = self else { return }
            
            let item = self.filteredArr.filter { $0.type == indexPath.section }
            self.setWritModeAndTransition(.modified, diaryType: .morning, task: item[indexPath.row])
            self.searchView.tableView.reloadData()
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [currdntDiaryModifing, currentDiaryDelete])
        }
    }
    
    func setWritModeAndTransition(_ mode: WriteMode, diaryType: MorningAndNight, task: Diary?) {
        let vc = WriteViewController(diarytype: diaryType, writeMode: mode)
        vc.data = task
        //        vc.fetch = fetchRealm
        //        vc.selectedDate = mainview.calendar.selectedDate ?? Date()
        //task nil 로 분기해보기
        
        switch mode {
            
        case .newDiary:
            print("====>🚀 작성화면으로 가기")
            transition(vc, transitionStyle: .push)
            switch diaryType {
            case .morning:
                vc.writeView.setWriteVCPlaceholder(type: .morning)
            case .night:
                vc.writeView.setWriteVCPlaceholder(type: .night)
                
            }
        case .modified:
            print("====>🚀 수정화면으로 가기")
            transition(vc, transitionStyle: .push)
            
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
   
        guard let text = searchController.searchBar.text else { return }
        fetch()
        guard let items = tasks else {
            print("===========>task를 받아올 수 없습니다")
            print(text)
            return
        }
   // 이제 타입별로 나눠서 뿌려줘야함
        self.filteredArr = items.where { $0.contents.contains("\(text)") }
        print(filteredArr, "filteredArr")
    
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchView.tableView.reloadData()
        dismiss(animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
}
