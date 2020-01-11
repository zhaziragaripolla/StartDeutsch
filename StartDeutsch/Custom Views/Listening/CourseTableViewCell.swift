//
//  CourseTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/11/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    private let gradientView = UIView()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.clipsToBounds = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(gradientView)
        gradientView.setRandomGradient()
        sendSubviewToBack(gradientView)
        gradientView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.9)
        })
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.center.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
