//
//  ImageCell.swift
//  CoreMLAwesomeness
//
//  Created by Lyle Christianne Jover on 1/25/18.
//  Copyright © 2018 OnionApps Inc. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(_ image: UIImage) {
        imageView.image = image
    }
    
    
}
