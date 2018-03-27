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
    private var parks: [String: [Park]] = [: ] {
        didSet{
            parksName = Array(parks.keys)
        }
    }
    
    var parksName: [String] = []
    
    init() {
        ParkAPIService.shared.delegate = self
    }
    
    func updateParks() {
        ParkAPIService.shared.fetch()
    }
    
    func parksNumber(parkName: String) -> Int {
        return parks[parkName]?.count ?? 0
    }
    
    func parkViewModel(indexPath: IndexPath) -> ParkViewModel{
        let parkName = parksName[indexPath.section]
        let park = parks[parkName]![indexPath.row]
        return ParkViewModel(park: park)
    }
    
    // MARK: - Park API service delegate
    
    func didSuccessFetchParks(_ parks: [String: [Park]]) {
        self.parks = parks
        print(parks.keys.count)
        print(parks.values.count)
        delegate?.didSuccessUpdateParks()
    }
    
    func didFailFetchParks(error: Error) {
        delegate?.didFailUpdateParks(error: error)
    }
    
}

