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
        
        let navigationtitleView = navigationTitleVIew()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationtitleView)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let morningFilteredArr = morningFilteredArr else {
            print("====> 아침검색어를 찾을 수 없습니다", #function)
            return 0
        }
        
        guard let nightFilteredArr = nightFilteredArr else {
            print("====> 밤검색어를 찾을 수 없습니다", #function)
            return 0
        }
        
        if section == 0 {
            return morningFilteredArr.count
           
        } else if section == 1 {
            return nightFilteredArr.count
            print(nightFilteredArr.count, "===========nightFilteredArr.count")
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
        
        guard let text = searchController.searchBar.text else { return UITableViewCell() }
        
        let Mitem = morningFilteredArr[indexPath.row]
        let Nitem = nightFilteredArr[indexPath.row]
        let attributedString = NSMutableAttributedString(string: cell.diaryLabel.text ?? "test")
        
        if self.isFiltering {
            fetch()
        if indexPath.section == 0 {
         
                cell.diaryLabel.text = Mitem.morning
                guard let Mtime = Mitem.morningTime else {
                    cell.dateLabel.text = "--:--"
                    return UITableViewCell()
                }
                cell.dateLabel.text = CustomFormatter.setTime(date: Mtime)
                
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.diaryLabel.text! as NSString).range(of: "\(text)"))
                cell.diaryLabel.attributedText = attributedString
        } else if indexPath.section == 1 {
            
                cell.diaryLabel.text = Nitem.night
                guard let Ntime = Nitem.nightTime else {
                    cell.dateLabel.text = "--:--"
                    return UITableViewCell()
                }
                cell.dateLabel.text = CustomFormatter.setTime(date: Ntime)
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (cell.diaryLabel.text! as NSString).range(of: "\(text)"))
                cell.diaryLabel.attributedText = attributedString
            }
        }
        return cell
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
        
        self.morningFilteredArr = items.where { $0.morning.contains("\(text)") }
        print(morningFilteredArr, "morningFilteredArr")
        self.nightFilteredArr = items.where { $0.night.contains("\(text)") }
        print(nightFilteredArr, "nightFilteredArr")
        searchView.tableView.reloadData()
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
