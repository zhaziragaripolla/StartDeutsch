//
//  CourseTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/10/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit

class CourseTableViewCell: UITableViewCell {
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.setRandomGradient()
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        gradientView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.9)
        })
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TestTableViewCell: UITableViewCell {
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.setRandomGradient()
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        gradientView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.9)
        })
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

