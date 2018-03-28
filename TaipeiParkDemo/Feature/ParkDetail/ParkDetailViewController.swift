//
//  ParkDetailViewController.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

class RelatedPlaceCell: UICollectionViewCell, RelatedPlaceViewModelDelegate {
    
    var viewModel: RelatedPlaceViewModel! {
        didSet {
            viewModel.delegate = self
            viewModel.fetchPhoto()
            nameLabel.text = viewModel.name
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func didFetchPhoto(image: UIImage?) {
        photoImageView.image = image
    }
}

class ParkDetailViewController: UIViewController, ParkViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: ParkDetailViewModel!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var relatedPlacesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.fetchPhoto()
        parkNameLabel.text = viewModel.parkName
        nameLabel.text = viewModel.name
        openTimeLabel.text = viewModel.openTime
        introductionTextView.text = viewModel.introduction
        
        introductionTextView.textContainerInset = UIEdgeInsets.zero
        introductionTextView.textContainer.lineFragmentPadding = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Park view model delegate
    
    func didFetchPhoto(image: UIImage?) {
        self.photoImageView.image = image
    }

    // MARK: - Collection view delegate
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.relatedPlacesNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedPlaceCell", for: indexPath) as! RelatedPlaceCell
        cell.viewModel = viewModel.relatedPlaceViewModel(index: indexPath.item)
        
        return cell
    }
    
}
