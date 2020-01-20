//
//  CardView.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/14/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CardView: UIView {
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let indicatorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor.lightGray.cgColor
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 30.0)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 30.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints({ make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.85 )
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        })
        
        addSubview(indicatorButton)
        indicatorButton.snp.makeConstraints({ make in
            make.top.equalTo(cardImageView.snp.bottom)
            make.leading.equalTo(cardImageView.snp.leading)
            make.bottom.lessThanOrEqualToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardView {
    func setState(_ answerState: AnswerState){
        switch answerState {
        case .correct:
            backgroundColor = Answer.setColor(.correct)
            indicatorButton.setImage(UIImage(named: "correct"), for: .normal)
            layer.borderColor = UIColor.white.cgColor
        case .mistake:
            backgroundColor = Answer.setColor(.mistake)
            indicatorButton.setImage(UIImage(named: "incorrect"), for: .normal)
            self.layer.borderColor = Answer.setColor(.mistake).cgColor
        case .chosen:
            backgroundColor = Answer.setColor(.chosen)
            indicatorButton.setImage(UIImage(systemName: "smallcircle.circle.fill"), for: .normal)
            layer.borderColor = Answer.setColor(.chosen).cgColor
        }
    }
    
    func reset(){
        backgroundColor = .white
        indicatorButton.setImage(nil, for: .normal)
        layer.borderColor = UIColor.white.cgColor
    }
}
