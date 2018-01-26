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

class ImageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    var selectedImage = UIImageView()
    var tap: UITapGestureRecognizer!
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.frame = CGRect(x: 0, y: view.frame.height, width: 375, height: 375)
            selectedImage.contentMode = .scaleAspectFill
            selectedImage.clipsToBounds = true
            selectedImage.tag = 46
            
            tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tap)
            
            selectedImage.image = image
            
            view.addSubview(selectedImage)
            
            dismiss(animated: true) {
                self.animateImageView(shouldShow: true)
            }
        } else{
            dismiss(animated: true, completion: nil)
        }

        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.bottomLabel.text = "TAP ON ANY PHOTO ABOVE"
        animateImageView(shouldShow: false)
    }
    
    func animateImageView(shouldShow: Bool) {
        if shouldShow{
            UIView.animate(withDuration: 0.2, animations: {
                self.selectedImage.frame = CGRect(x: 0, y: 146, width: 375, height: 375)
                self.makePrediction(self.selectedImage.image!)
            })
        } else{
            UIView.animate(withDuration: 0.2, animations: {
                self.selectedImage.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 375)
                
            }, completion: { (finished) in
                for subview in self.view.subviews{
                    if subview.tag == 46 {
                        subview.removeFromSuperview()
                    }
                }
            })
        }
    }
    
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    

}

