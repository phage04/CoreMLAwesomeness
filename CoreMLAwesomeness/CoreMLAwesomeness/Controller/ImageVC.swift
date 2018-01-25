//
//  ViewController.swift
//  CoreMLAwesomeness
//
//  Created by Lyle Christianne Jover on 1/25/18.
//  Copyright © 2018 OnionApps Inc. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ImageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        else { return UICollectionViewCell() }
        
        let image = foodImages[indexPath.row]
        cell.configureCell(image)
        
        return cell
    }
    
    func makePrediction(_ image: UIImage) {
        
    }
    

}

