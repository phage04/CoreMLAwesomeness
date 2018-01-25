//
//  GridFlowLayout.swift
//  CoreMLAwesomeness
//
//  Created by Lyle Christianne Jover on 1/25/18.
//  Copyright © 2018 OnionApps Inc. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        minimumLineSpacing = 1.0
        minimumInteritemSpacing = 1.0
        scrollDirection = .vertical
    }
    
    override var itemSize: CGSize {
        set {}
        get{
            
            let numberOfColumns: CGFloat = 3
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
}
