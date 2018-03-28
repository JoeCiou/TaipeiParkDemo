//
//  ParkViewModel.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/27.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

@objc protocol ParkViewModelDelegate {
    func didFetchPhoto(image: UIImage?)
}

class ParkViewModel {
    
    private(set) weak var park: Park!
    weak var delegate: ParkViewModelDelegate?
    private var fetchTask: URLSessionTask?
    
    var parkName: String {
        return park.parkName
    }
    var name: String {
        return park.name
    }
    var introduction: String {
        return park.introduction
    }
    
    init(park: Park) {
        self.park = park
    }
    
    func fetchPhoto() {
        if let url = URL(string: park!.imageURLString) {
            fetchTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                self.fetchTask = nil
                guard error == nil else {
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.delegate?.didFetchPhoto(image: image)
                    }
                }
            })
            fetchTask?.resume()
        }
    }
    
    func cancelFetchPhoto() {
        if let task = fetchTask, task.state == .running {
            task.cancel()
        }
    }
    
}
