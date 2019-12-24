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
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textColor = .blue
        return button
    }
    
    static func makeForBinaryQuestion(_ state: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textColor = .blue
        if state {
            button.setTitle("Richtig", for: .normal)
        }
        else {
            button.setTitle("Falsch", for: .normal)
        }
        return button
    }
    
    func defineAnswerState()-> Bool {
        return self.titleLabel?.text == "Richtig" ? true : false
    }
}
