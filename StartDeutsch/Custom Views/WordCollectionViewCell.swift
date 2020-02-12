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
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 18
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.clipsToBounds = true
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 1
        label.textColor = .white
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 18
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setRandomGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

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
        super.init(coder: coder)
    }

}
