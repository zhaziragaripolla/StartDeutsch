//
//  GradientLayer.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/7/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

extension UIView {
    func setRandomGradient(){
        let gradientLayer = CAGradientLayer()
        var currentColorSet: Int = 0
        var colorSet: [UIColor] = []
        colorSet.append(UIColor(hexString: "#f8b646"))
        colorSet.append(UIColor(hexString: "#dd653c"))
        colorSet.append(UIColor(hexString: "#28ada5"))
        colorSet.append(UIColor(hexString: "#f7514c"))
        colorSet.append(UIColor(hexString: "#2bc988"))
        colorSet.append(UIColor(hexString: "#f0ce41"))
        colorSet.append(UIColor(hexString: "#476096"))
        colorSet.append(UIColor(hexString: "#FE6A88"))
        colorSet.append(UIColor(hexString: "#7C30FE"))
        currentColorSet = Int(arc4random_uniform(UInt32(colorSet.count)))
        gradientLayer.colors = [UIColor.purple.cgColor, colorSet[currentColorSet].cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1 )
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setThemeGradientLayer(){
        let gradientLayer = CAGradientLayer()
        let color1 = UIColor(hexString: "692AA4")
        let color2 = UIColor(hexString: "B638AF")
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1 )
        layer.borderColor = UIColor.white.cgColor
//        layer.cornerRadius = 10
        clipsToBounds = true
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
