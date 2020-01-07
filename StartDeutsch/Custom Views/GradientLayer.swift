//
//  GradientLayer.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/7/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class GradientLayer: CAGradientLayer {
    
    var colorSet = [UIColor]()
    var currentColorSet: Int = 0
    
    func createColorSet() {
        colorSet.append(UIColor(hexString: "#f8b646"))
        colorSet.append(UIColor(hexString: "#dd653c"))
        colorSet.append(UIColor(hexString: "#28ada5"))
        colorSet.append(UIColor(hexString: "#f7514c"))
        colorSet.append(UIColor(hexString: "#2bc988"))
        colorSet.append(UIColor(hexString: "#f0ce41"))
        colorSet.append(UIColor(hexString: "#476096"))
        colorSet.append(UIColor(hexString: "#FE6A88"))
        colorSet.append(UIColor(hexString: "#7C30FE"))
    }
    
    override init(){
        super.init()
        createColorSet()
        currentColorSet = Int(arc4random_uniform(UInt32(colorSet.count)))
        self.colors = [UIColor.purple.cgColor, colorSet[currentColorSet].cgColor]
        self.startPoint = CGPoint(x: 0, y: 0)
        self.endPoint = CGPoint(x: 1, y: 1 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
