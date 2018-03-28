//
//  ParkDetailViewController.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

class RelatedPlaceCell: UICollectionViewCell, RelatedPlaceViewModelDelegate {
    
    var viewModel: RelatedPlaceViewModel? {
        didSet {
            if let oldViewModel = oldValue {
                oldViewModel.delegate = nil
            }
            if let viewModel = viewModel {
                viewModel.delegate = self
                viewModel.fetchPhoto()
                nameLabel.text = viewModel.name
            }
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Related place view model delegate
    
    func didFetchPhoto(image: UIImage?) {
        photoImageView.image = image
    }
}

class ParkDetailViewController: UIViewController, ParkViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: ParkDetailViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var relatedPlacesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introductionTextView.textContainerInset = UIEdgeInsets.zero
        introductionTextView.textContainer.lineFragmentPadding = 0
        
        updateInfomation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateInfomation() {
        viewModel.fetchPhoto()
        parkNameLabel.text = viewModel.parkName
        nameLabel.text = viewModel.name
        openTimeLabel.text = viewModel.openTime
        introductionTextView.text = viewModel.introduction
        relatedPlacesCollectionView.reloadData()
        relatedPlacesCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func handleBackClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Park view model delegate
    
    func didFetchPhoto(image: UIImage?) {
        self.photoImageView.image = image
    }

    // MARK: - Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel = viewModel.parkDetailViewModel(relatedPlacesIndex: indexPath.item)
        updateInfomation()
    }
    
    // MARK: - Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (viewModel.relatedPlacesNumber == 0) {
            collectionView.setEmptyMessage("目前沒有相關景點")
        } else {
            collectionView.restore()
        }
        
        return viewModel.relatedPlacesNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedPlaceCell", for: indexPath) as! RelatedPlaceCell
        cell.viewModel = viewModel.relatedPlaceViewModel(index: indexPath.item)
        
        return cell
    }
    
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
