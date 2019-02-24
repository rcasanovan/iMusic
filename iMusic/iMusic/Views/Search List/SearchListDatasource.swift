//
//  SearchListDatasource.swift
//  iMusic
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import UIKit

class SearchListDatasource: NSObject {
    
    public var items: [TrackViewModel]
    
    public override init() {
        self.items = []
        super.init()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchListDatasource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = items[indexPath.row]
        cell.bindWithViewModel(viewModel)
        
        return cell
    }
    
}
