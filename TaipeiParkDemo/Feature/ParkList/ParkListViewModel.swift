//
//  ParkListViewModel.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import Foundation

@objc protocol ParkListViewModelDelegate {
    
    func didSuccessUpdateParks()
    func didFailUpdateParks(error: Error)
    
}

class ParkListViewModel: ParkAPIServiceDelegate {
    
    weak var delegate: ParkListViewModelDelegate?
    var parks: [Park] = []
    
    init() {
        ParkAPIService.shared.delegate = self
    }
    
    func updateParks() {
        ParkAPIService.shared.fetch()
    }
    
    func parkViewModel(index: Int) -> ParkViewModel{
        return ParkViewModel(park: parks[index])
    }
    
    // MARK: - Park API service delegate
    
    func didSuccessFetchParks(_ parks: [Park]) {
        self.parks = parks
        delegate?.didSuccessUpdateParks()
    }
    
    func didFailFetchParks(error: Error) {
        delegate?.didFailUpdateParks(error: error)
    }
    
}

