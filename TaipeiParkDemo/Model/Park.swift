//
//  Park.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import Foundation

class Park: NSObject {
    
    let parkName: String
    let name: String
    let openTime: String
    let imageURLString: String
    let introduction: String
    
    init(parkName: String, name: String, openTime: String, imageURLString: String, introduction: String) {
        self.parkName = parkName
        self.name = name
        self.openTime = openTime
        self.imageURLString = imageURLString
        self.introduction = introduction
        super.init()
    }
    
}
