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
        let reference = Storage.storage().reference(withPath: path)
        self.sd_setImage(with: reference)
    }
}

extension UIButton {
    static func makeForAnswerChoice(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 300.0)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 40.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }
    
    static func makeForBinaryQuestion(_ state: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.cgColor
        let title = state ? "Richtig" : "Falsch"
        button.setTitle(title, for: .normal)
        let tag = state ? 1 : 0
        button.tag = tag
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 100.0)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 40.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }
    
    func defineAnswerState()-> Bool {
        return self.titleLabel?.text == "Richtig" ? true : false
    }
}


extension UILabel {
    static func make()-> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
}
