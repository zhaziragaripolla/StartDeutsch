//
//  CourseTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/11/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    public let gradientView = UIView()
    
    private let courseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.clipsToBounds = true
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        gradientView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.9)
        })
        gradientView.layer.cornerRadius = 15
        gradientView.setThemeGradientLayer()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(courseImageView)
        courseImageView.snp.makeConstraints({ make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.5)
        })
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(courseImageView.snp.trailing)
            make.trailing.equalToSuperview()
        })
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints({ make in
            make.top.equalTo(courseImageView.snp.bottom)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalTo(250)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(course: Course){
        titleLabel.text = course.title
        courseImageView.image = UIImage(named: "\(course.aliasName).png")
        detailLabel.text = course.descriptionText
    }

}
