//
//  SearchPersonViewController.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//


import UIKit
import RxSwift
import RxCocoa

class SearchPersonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    var personSearchViewModel: SearchPersonViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tableView.backgroundColor = .red
        
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationBar()
        guard  let searchBar = self.navigationItem.searchController?.searchBar else {
            fatalError("wrong controller")
        }
        
        let vmInputs = SearchPersonViewModelInputs(marvelRepository: MarvelRepository.shared,
                                                  query: searchBar.rx.text.orEmpty.asDriver())
        personSearchViewModel = SearchPersonViewModel(vmInputs)
        
        personSearchViewModel.outputs.persons
            .drive(onNext: {[unowned self] (_) in
                self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
            })
            .disposed(by: disposeBag)
        
        personSearchViewModel.outputs.isFetching
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        personSearchViewModel.outputs.info
            .drive(onNext: {[unowned self] (info) in
                self.infoLabel.isHidden = !self.personSearchViewModel.outputs.hasInfo
                self.infoLabel.text = info
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        setupTableView()
    }
    
    private func setupNavigationBar() {
       
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerReusableCell(MarvelTableViewCell.self)
    }
    
}


extension SearchPersonViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personSearchViewModel.outputs.numberOfPersons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MarvelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = .red
        cell.configure(with: personSearchViewModel.outputs.viewModelItemForMarvel(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vm = personSearchViewModel.outputs.viewModelDetailForMarvel(at: indexPath.row), let vcDetail = MarvelDetailViewController.createMarvelDetailController(detailViewModel: vm){
            self.navigationController?.pushViewController(vcDetail, animated: true)
        }
    }
}

