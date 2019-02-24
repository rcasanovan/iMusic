//
//  SearchListDatasource.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class SearchListDatasource: NSObject {
    
    public var items: [TrackViewModel] {
        didSet {
            //__ This is a little trick.
            //__ I created a dicctionary with keys = $0.dt
            //__ and then I created a sorted keys array.
            //__ Why am I doing this here?
            //__ easy -> to do this logic once :)
            switch sortType {
            case .artistName:
                dictionary = Dictionary(grouping: items, by: { $0.artistName })
            case .genre:
                dictionary = Dictionary(grouping: items, by: { $0.primaryGenreName })
            case .length:
                dictionary = Dictionary(grouping: items, by: { $0.trackDuration })
            case .price:
                dictionary = Dictionary(grouping: items, by: { $0.trackPrice ?? "" })
            }
            keysArray = Array(dictionary.keys).sorted(by: { $0 < $1 })
        }
    }
    
    public var sortType: SortType
    
    private var dictionary: Dictionary<String, [TrackViewModel]>
    private var keysArray: [String]
    
    public override init() {
        self.items = []
        self.dictionary = [:]
        self.keysArray = []
        self.sortType = .artistName
        super.init()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchListDatasource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch sortType {
        case .artistName:
            dictionary = Dictionary(grouping: items, by: { $0.artistName })
        case .genre:
            dictionary = Dictionary(grouping: items, by: { $0.primaryGenreName })
        case .length:
            dictionary = Dictionary(grouping: items, by: { $0.trackDuration })
        case .price:
            dictionary = Dictionary(grouping: items, by: { $0.trackPrice ?? "" })
        }
        return dictionary.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let elementsPerSection = dictionary[keysArray[section]] else {
            return 0
        }
        return elementsPerSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let elementsPerSection = dictionary[keysArray[indexPath.section]]  {
            let viewModel = elementsPerSection[indexPath.row]
            cell.bindWithViewModel(viewModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackHeaderView.identifier, for: indexPath) as? TrackHeaderView, let elementsPerSection = dictionary[keysArray[indexPath.section]] else {
            return UICollectionReusableView()
        }
        let viewModel = elementsPerSection[0]
        
        switch sortType {
        case .artistName:
            headerView.title = viewModel.artistName
        case .genre:
            headerView.title = viewModel.primaryGenreName
        case .length:
            headerView.title = viewModel.trackDuration
        case .price:
            headerView.title = viewModel.trackPrice
        }
    
        return headerView
    }
    
}
