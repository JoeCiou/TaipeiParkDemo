//
//  ParkAPIService.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/26.
//  Copyright © 2018年 joe. All rights reserved.
//

import Foundation

@objc protocol ParkAPIServiceDelegate {
    
    func didSuccessFetchParks(_ parks: [String: [Park]])
    func didFailFetchParks(error: Error)
    
}

class ParkAPIService {
    
    static let shared: ParkAPIService = ParkAPIService(urlAPI: URL(string: TaipeiParkAPI)!)
    
    let urlAPI: URL
    weak var delegate: ParkAPIServiceDelegate?
    
    init(urlAPI: URL) {
        self.urlAPI = urlAPI
    }
    
    func fetch() {
        var request = URLRequest(url: urlAPI)
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.didFailFetchParks(error: error!)
                }
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    let result = json["result"] as! [String: Any]
                    let results = result["results"] as! [[String: String]]
                    
                    var parks: [String: [Park]] = [: ]
                    for parkInfo in results {
                        let parkName = parkInfo["ParkName"]!
                        let park = Park(parkName: parkName,
                                        name: parkInfo["Name"]!,
                                        openTime: parkInfo["OpenTime"]!,
                                        imageURLString: parkInfo["Image"]!,
                                        introduction: parkInfo["Introduction"]!)
                        parks[parkName] = (parks[parkName] ?? []) + [park]
                    }
                    DispatchQueue.main.async {
                        self.delegate?.didSuccessFetchParks(parks)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.delegate?.didFailFetchParks(error: error)
                    }
                }
            }
        }
        task.resume()
    }
    
}

