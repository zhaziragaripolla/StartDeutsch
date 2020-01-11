//
//  UIImageView+Extension.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
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
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 20.0)
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
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 200.0)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 20.0)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        return button
    }
    
    func defineAnswerState()-> Bool {
        return self.titleLabel?.text == "Richtig" ? true : false
    }
}
