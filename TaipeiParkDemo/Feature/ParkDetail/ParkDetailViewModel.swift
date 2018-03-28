//
//  ParkDetailViewModel.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

class ParkDetailViewModel: ParkViewModel {
    
    private let relatedPlaces: [Park]
    
    var openTime: String {
        return park!.openTime
    }
    
    var relatedPlacesNumber: Int {
        return relatedPlaces.count
    }
    
    init(park: Park, relatedPlaces: [Park]) {
        self.relatedPlaces = relatedPlaces
        super.init(park: park)
    }
    
    func relatedPlaceViewModel(index: Int) -> RelatedPlaceViewModel {
        return RelatedPlaceViewModel(park: relatedPlaces[index])
    }
    
}
