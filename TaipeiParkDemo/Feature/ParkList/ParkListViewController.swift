//
//  ParkListViewController.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit
import Hero

class ParkCell: UITableViewCell, ParkViewModelDelegate {
    
    var viewModel: ParkViewModel? {
        didSet {
            if let oldViewModel = oldValue {
                oldViewModel.delegate = nil
            }
            if let viewModel = viewModel {
                viewModel.delegate = self
                viewModel.fetchPhoto()
                parkNameLabel.text = viewModel.parkName
                nameLabel.text = viewModel.name
                introductionTextView.text = viewModel.introduction
            }
        }
    }
    
    @IBOutlet weak var cardContentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        introductionTextView.textContainerInset = UIEdgeInsets.zero
        introductionTextView.textContainer.lineFragmentPadding = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cardContentView.hero.id = selected ? "CardContentView": nil
        photoImageView.hero.id = selected ? "PhotoImageView": nil
        parkNameLabel.hero.id = selected ? "ParkNameLabel": nil
        nameLabel.hero.id = selected ? "NameLabel": nil
        introductionTextView.hero.id = selected ? "IntroductionTextView": nil
    }
    
    // MARK: - Park view model delegate
    
    func didFetchPhoto(image: UIImage?) {
        photoImageView.image = image
    }
}

class ParkListViewController: UIViewController, ParkListViewModelDelegate, UITableViewDelegate, UITableViewDataSource {

    let viewModel: ParkListViewModel = ParkListViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        viewModel.delegate = self
        viewModel.updateParks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ParkDetailViewController,
            let indexPath = sender as? IndexPath {
            vc.viewModel = viewModel.parkDetailViewModel(indexPath: indexPath)
        }
    }
    
    // MARK: - Park list view model delegate
    
    func didSuccessUpdateParks() {
        tableView.reloadData()
    }
    
    func didFailUpdateParks(error: Error) {
        let alert = UIAlertController(title: "取得資料失敗",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "重試", style: .default) { (_) in
            self.viewModel.updateParks()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.parksName.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let parkName = viewModel.parksName[section]
        return viewModel.parksNumber(parkName: parkName)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParkCell
        cell.viewModel = viewModel.parkViewModel(indexPath: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = viewModel.parksName[section]
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        contentView.addSubview(titleLabel)
        headerView.addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        contentView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
        contentView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        contentView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
}
