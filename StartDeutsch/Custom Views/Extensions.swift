//
//  UIImageView+Extension.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import FirebaseUI

extension UIImageView {
    func load(from path: String) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        let reference = Storage.storage().reference(withPath: path)
        self.sd_setImage(with: reference)
    }
}

extension UIButton {
    static func makeForAnswerChoice(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
               let calculatedFontSize = screenWidth / 375 * 16
            button.titleLabel?.font = .boldSystemFont(ofSize: calculatedFontSize)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 250.0)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 100.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }
    
    static func makeForBinaryQuestion(_ state: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
           let calculatedFontSize = screenWidth / 375 * 18
        button.titleLabel?.font = .boldSystemFont(ofSize: calculatedFontSize)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        let title = state ? "Richtig" : "Falsch"
        button.setTitle(title, for: .normal)
        let tag = state ? 1 : 0
        button.tag = tag
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 45)
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 110.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }
    
    func defineAnswerState()-> Bool {
        return self.titleLabel?.text == "Richtig" ? true : false
    }
    
    func setState(_ answerState: AnswerState){
        switch answerState {
        case .correct:
            self.backgroundColor = Answer.setColor(.correct)
            self.setTitleColor(.white, for: .normal)
            self.setImage(UIImage(named: "correct"), for: .normal)
        case .mistake:
            self.backgroundColor = Answer.setColor(.mistake)
            self.setTitleColor(.white, for: .normal)
            self.setImage(UIImage(named: "incorrect"), for: .normal)
            self.layer.borderColor = Answer.setColor(.mistake).cgColor
        case .chosen:
            self.backgroundColor = Answer.setColor(.chosen)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderColor = Answer.setColor(.chosen).cgColor
        }
    }
    
    func reset(){
        backgroundColor = .white
        setTitleColor(.systemBlue, for: .normal)
        setImage(nil, for: .normal)
        layer.borderColor = UIColor.white.cgColor
    }
    
}


extension UILabel {
    static func make()-> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 14
        label.font = .boldSystemFont(ofSize: calculatedFontSize)
        label.numberOfLines = 5
        label.textColor = .white
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        let heightConstraint = label.heightAnchor.constraint(equalToConstant: 60)
        let widthConstraint = label.widthAnchor.constraint(equalToConstant: 300.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return label
    }
}
