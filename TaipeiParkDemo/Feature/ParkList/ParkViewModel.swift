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
    
    private weak var park: Park?
    weak var delegate: ParkViewModelDelegate?
    
    var parkName: String {
        return park!.parkName
    }
    var name: String {
        return park!.name
    }
    var introduction: String {
        return park!.introduction
    }
    
    init(park: Park) {
        self.park = park
    }
    
    func fetchPhoto() {
        if let url = URL(string: park!.imageURLString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.delegate?.didFetchPhoto(image: image)
                    }
                }
            })
            task.resume()
        }
    }
    
}
