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
            //__ This is to build the sections and add a headerview
            //__ with the day string.
            //__ Why am I doing this here?
            //__ easy -> to do this logic once :)
            dictionary = Dictionary(grouping: items, by: { $0.artistName })
            keysArray = Array(dictionary.keys).sorted(by: { $0 < $1 })
        }
    }
    
    private var dictionary: Dictionary<String, [TrackViewModel]>
    private var keysArray: [String]
    
    public override init() {
        self.items = []
        dictionary = [:]
        keysArray = []
        super.init()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchListDatasource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let dictionary = Dictionary(grouping: items, by: { $0.artistName })
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
        headerView.title = viewModel.artistName
        return headerView
    }
    
}
