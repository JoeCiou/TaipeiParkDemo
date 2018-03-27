//
//  ParkListViewController.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

class ParkCell: UITableViewCell, ParkViewModelDelegate {
    
    var viewModel: ParkViewModel? {
        didSet{
            if let viewModel = viewModel{
                viewModel.delegate = self
                viewModel.fetchPhoto()
                parkNameLabel.text = viewModel.parkName
                nameLabel.text = viewModel.name
                introductionTextView.text = viewModel.introduction
            }
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    
    // MARK: - Park view model delegate
    
    func didFetchPhoto(image: UIImage?) {
        photoImageView.image = image
    }
}

class ParkListViewController: UITableViewController, ParkListViewModelDelegate {

    let viewModel: ParkListViewModel = ParkListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.updateParks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Park list view model delegate
    
    func didSuccessUpdateParks() {
        tableView.reloadData()
    }
    
    func didFailUpdateParks(error: Error) {
        // TODO: retry
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.parks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParkCell
        cell.viewModel = viewModel.parkViewModel(index: indexPath.row)

        return cell
    }

}
