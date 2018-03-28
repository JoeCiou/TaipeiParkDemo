//
//  Extension.swift
//  TaipeiParkDemo
//
//  Created by Joe on 2018/3/28.
//  Copyright © 2018年 joe. All rights reserved.
//

import UIKit

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
