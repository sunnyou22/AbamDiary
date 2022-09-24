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
    
    var morningFilteredArr: Results<Diary>! {
        didSet {
            searchView.tableView.reloadData()
            print("서치테이블뷰 아침필터 tasks ~♻️ 리로등")
        }
    }
    
    var nightFilteredArr: Results<Diary>! {
        didSet {
            searchView.tableView.reloadData()
            print("서치테이블뷰 밤필터 tasks ~♻️ 리로등")
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
        return 88
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            guard let morningFilteredArr = morningFilteredArr else {
                print("====> 아침검색어를 찾을 수 없습니다", #function)
                return 0
            }
            print(morningFilteredArr.count, "==========morningFilteredArr.count")
            return morningFilteredArr.count
            
        } else if section == 1 {
            guard let nightFilteredArr = nightFilteredArr else {
                print("====> 밤검색어를 찾을 수 없습니다", #function)
                return 0
            }
            print(nightFilteredArr.count, "===========nightFilteredArr.count")
            return nightFilteredArr.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        
        guard let morningFilteredArr = morningFilteredArr else {
            print("====> 아침filteredArr이 nil 입니다", #function)
            return UITableViewCell()
        }
        
        guard let nightFilteredArr = nightFilteredArr else {
            print("====> 밤 filteredArr이 nil 입니다", #function)
            return UITableViewCell()
        }
        
        print(morningFilteredArr, nightFilteredArr)
        
        guard let text = searchController.searchBar.text else { return UITableViewCell() }
        
        if self.isFiltering {
            
            if indexPath.section == 0 {
                
                let Mitem = morningFilteredArr[indexPath.row]
                
                guard let Mtime = Mitem.morningTime else {
                    cell.dateLabel.text = "--:--"
                    return UITableViewCell()
                }
                
                cell.diaryLabel.text = Mitem.morning
                cell.dateLabel.text = CustomFormatter.setTime(date: Mtime)
                
                cell.setMornigAndNightConfig(index: 0)
                
                let attributedString = NSMutableAttributedString(string: cell.diaryLabel.text ?? "test")
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.diaryLabel.text! as NSString).range(of: "\(text)"))
                cell.diaryLabel.attributedText = attributedString
                
                
            } else if indexPath.section == 1 {
                let Nitem = nightFilteredArr[indexPath.row]
                cell.diaryLabel.text = Nitem.night
                guard let Ntime = Nitem.nightTime else {
                    cell.dateLabel.text = "--:--"
                    return UITableViewCell()
                }
                cell.dateLabel.text = CustomFormatter.setTime(date: Ntime)
                cell.setMornigAndNightConfig(index: 1)
                let attributedString = NSMutableAttributedString(string: cell.diaryLabel.text ?? "test")
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.diaryLabel.text! as NSString).range(of: "\(text)"))
                cell.diaryLabel.attributedText = attributedString
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let currentDiaryDelete = UIAction(title: "해당 일기 삭제") { [weak self] _ in
            let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
            let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"
            
            guard let self = self else { return }
            
            if indexPath.section == 0 {
                let Mitem = self.morningFilteredArr[indexPath.row]
                do {
                    try OneDayDiaryRepository.shared.localRealm.write {
                        Mitem.morning = nil
                    }
                } catch {
                    print("search뷰컨 삭제 실패")
                }
            } else {
                let Nitem = self.nightFilteredArr[indexPath.row]
                do {
                    try OneDayDiaryRepository.shared.localRealm.write {
                        Nitem.night = nil
                    }
                } catch {
                    print("search뷰컨 삭제 실패")
                }
            }
            self.searchView.tableView.reloadData()
        }
        
        let currdntDiaryModifing = UIAction(title: "수정") { [weak self] _ in
            
            guard let self = self else { return }
            if indexPath.section == 0 {
                let Mitem = self.morningFilteredArr[indexPath.row]
                Mitem.morning != nil ? self.setWritModeAndTransition(.modified, diaryType: .morning, task: Mitem) : self.setWritModeAndTransition(.newDiary, diaryType: .morning, task: Mitem)
            } else {
                let Nitem = self.nightFilteredArr[indexPath.row]
                Nitem.night != nil ? self.setWritModeAndTransition(.modified, diaryType: .night, task: Nitem) : self.setWritModeAndTransition(.newDiary, diaryType: .night, task: Nitem)
            }
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
        let morningPlaceholer = "오늘 아침! 당신의 한줄은 무엇인가요?"
        let nightPlaceholder = "오늘 밤! 당신의 한줄은 무엇인가요?"
        
        guard let text = searchController.searchBar.text else { return }
        fetch()
        guard let items = tasks else {
            print("===========>task를 받아올 수 없습니다")
            print(text)
            return
        }
        
        self.morningFilteredArr = items.where { $0.morning.contains("\(text)") && $0.morning != morningPlaceholer}
        print(morningFilteredArr, "morningFilteredArr")
        self.nightFilteredArr = items.where { $0.night.contains("\(text)") && $0.night != nightPlaceholder}
        print(nightFilteredArr, "nightFilteredArr")
        //        searchView.tableView.reloadData()
        
        print(morningFilteredArr, nightFilteredArr, "========업데이트")
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
