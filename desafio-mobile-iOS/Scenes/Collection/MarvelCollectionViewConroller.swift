//
//  MarvelCollectionViewConroller.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit
import RxCocoa
import RxSwift

class MarvelCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorInfoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryCollectionSegControl: UISegmentedControl!
    
    var marvelCollectionViewModel: MarvelCollectionViewModel!
    let disposeBag = DisposeBag()
    
    fileprivate enum UIContants {
        static let margin: CGFloat = 15.0
        static let nbrOfItemsInARow: CGFloat = 2.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSegmentedController()
        
        let collectionTypeSelected = categoryCollectionSegControl.rx.selectedSegmentIndex
            .map { MarvelCollection(index: $0) ?? .popular }
            .asDriver(onErrorJustReturn: .popular)
        
        let mvInputs = MarvelCollectionViewModelInputs(marvelRepository: MarvelRepository.shared, collectionTypeSelected: collectionTypeSelected)
        
        marvelCollectionViewModel = MarvelCollectionViewModel(mvInputs)
        
        marvelCollectionViewModel.outputs.persons.drive(
            onNext: {[unowned self] (_) in
                self.collectionView.reloadSections(IndexSet(integersIn: 0...0))}).disposed(by: disposeBag)
        
        marvelCollectionViewModel.outputs.error.drive(onNext: {[unowned self] (error) in self.errorInfoLabel.isHidden = !self.marvelCollectionViewModel.outputs.hasError
            self.errorInfoLabel.text = error
        }).disposed(by: disposeBag)
    }
    
    func setupCollectionView(){
        view.backgroundColor = .red
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(MarvelCollectionViewCell.self)
    }
    func setupSegmentedController(){
        //self.categoryCollectionSegControl.isHidden = true
        self.categoryCollectionSegControl.removeAllSegments()
        self.categoryCollectionSegControl.insertSegment(withTitle: "The Best Marvel's Character", at: 0, animated: true)
        self.categoryCollectionSegControl.selectedSegmentIndex = 0
    }

}

extension MarvelCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marvelCollectionViewModel.outputs.numberOfPersons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarvelCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: marvelCollectionViewModel.outputs.viewModelItemForMarvel(at: indexPath.row))
        return cell
    }
}

extension MarvelCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let vm = marvelCollectionViewModel.outputs.viewModelDetailForMarvel(at: indexPath.row), let vcDetail = MarvelDetailViewController.createMarvelDetailController(detailViewModel: vm) {
            self.navigationController?.pushViewController(vcDetail, animated: true)
        }
    }
}

extension MarvelCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let cellWidth = (screenSize.width - (UIContants.margin * (UIContants.nbrOfItemsInARow + 1))) / UIContants.nbrOfItemsInARow
        let cellHeight = cellWidth * ImageSize.heightPosterRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.self.init(top: UIContants.margin, left: UIContants.margin, bottom: UIContants.margin, right: UIContants.margin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIContants.margin
    }
    
}

