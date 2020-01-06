//
//  WordCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/6/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class WordCollectionViewCell: UICollectionViewCell {
    public let themeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.clipsToBounds = true
        return label
    }()
    
    public let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var colorSets = [UIColor]()
    var currentColorSet: Int = 0
    
    func createColorSets() {
        colorSets.append(UIColor(hexString: "#f8b646"))
        colorSets.append(UIColor(hexString: "#dd653c"))
        colorSets.append(UIColor(hexString: "#28ada5"))
        colorSets.append(UIColor(hexString: "#f7514c"))
        colorSets.append(UIColor(hexString: "#2bc988"))
        colorSets.append(UIColor(hexString: "#f0ce41"))
        colorSets.append(UIColor(hexString: "#476096"))
        colorSets.append(UIColor(hexString: "#FE6A88"))
        colorSets.append(UIColor(hexString: "#7C30FE"))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        createColorSets()
        currentColorSet = Int(arc4random_uniform(UInt32(colorSets.count)))
        
        let gradientLayer = CAGradientLayer()
        let color = colorSets[currentColorSet].withAlphaComponent(0.5)
        gradientLayer.colors = [UIColor.purple.cgColor, color.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1 )
        self.contentView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = contentView.bounds

        addSubview(themeLabel)
        themeLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        })
        
        addSubview(wordLabel)
        wordLabel.snp.makeConstraints({ make in
            make.top.equalTo(themeLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
