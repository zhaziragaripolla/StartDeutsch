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
    
    let readingColor: UIColor = .init(hexString: "FFD042")
    let speakingColor: UIColor = .init(hexString: "FFA08E")
    let writingColor: UIColor = .init(hexString: "68DAE2")
    let listeningColor: UIColor = .init(hexString: "68DAE2")
    
    public let courseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

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
        sendSubviewToBack(gradientView)
        gradientView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.9)
        })
        gradientView.layer.cornerRadius = 30
//        gradientView.layer.borderWidth = 1.0
        gradientView.setRandomGradient()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(courseImageView)
        courseImageView.snp.makeConstraints({ make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.7)
//            make.centerY.equalToSuperview().multipliedBy(0.)
        })
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(courseImageView.snp.trailing)
            make.top.trailing.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(course: Course){
//        switch course.aliasName{
//        case "listening":
//            gradientView.backgroundColor = .init(hexString: "68DAE2")
//        case "reading":
//            gradientView.backgroundColor = .init(hexString: "FFD042")
//        case "writing":
//            gradientView.backgroundColor = .init(hexString: "B797F3")
//        case "speaking":
//            gradientView.backgroundColor = .init(hexString: "FFA08E")
//        default:
//            gradientView.backgroundColor = .none
//        }
        gradientView.setRandomGradient()
        titleLabel.text = course.title
        courseImageView.image = UIImage(named: "\(course.aliasName).png")
    }

}
