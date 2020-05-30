//
//  TestTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/30/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit


class TestTableViewCell: UITableViewCell{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let testImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(testImageView)
            testImageView.image = UIImage(named: "test.png")
            testImageView.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview()
                make.width.height.equalTo(30)
            })
            
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalTo(testImageView.snp.trailing).offset(5)
                make.trailing.lessThanOrEqualToSuperview()
                make.bottom.equalToSuperview()
            })
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
}
