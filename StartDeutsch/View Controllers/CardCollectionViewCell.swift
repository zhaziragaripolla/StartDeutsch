//
//  CardCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/6/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
