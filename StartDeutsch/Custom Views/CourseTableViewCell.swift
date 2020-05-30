//
//  CourseTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/11/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell{
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let courseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(courseImageView)
        courseImageView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.width.height.equalTo(30)
        })
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
           make.top.equalToSuperview().offset(10)
            make.leading.equalTo(courseImageView.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(course: Course){
        titleLabel.text = course.title
        courseImageView.image = UIImage(named: "\(course.aliasName.lowercased()).png")
    }
}
