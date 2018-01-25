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
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
        let request = VNCoreMLRequest(model: model, completionHandler: handleResults)
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        }catch {
            debugPrint("ERROR: ", error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else {return}
        makePrediction(cell.imageView.image!)
    }
    
    func handleResults(request: VNRequest, error: Error?){
        guard let results = request.results as? [VNClassificationObservation] else {return}
        let bestResult = results[0]
        let id = bestResult.identifier.capitalized
        let confidence = bestResult.confidence * 100
        let confidenceDecimal = String.init(format: "%.2f", confidence)
        print(id, "\(confidenceDecimal)%")
        
        bottomLabel.text = "\(id): \(confidenceDecimal)%"
    }

}

