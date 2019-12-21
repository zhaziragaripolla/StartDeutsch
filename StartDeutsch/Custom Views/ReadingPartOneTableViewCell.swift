//
//  ReadingPartOneTableViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseUI

fileprivate extension UILabel {
    static func make(_ text: String)-> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.text = text
        return label
    }
}

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

class ReadingPartOneTableViewCell: UITableViewCell {
//
//    private var trueButton: UIButton {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 18)
//        button.setTitle("Richtig", for: .normal)
//        button.tag = 1
//        return button
//    }
//
//    private var falseButton: UIButton {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 18)
//        button.setTitle("Falsch", for: .normal)
//        button.tag = 0
//        return button
//    }
    
    private var answerButtonsStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(true))
        stackView.addArrangedSubview(UIButton.makeForBinaryQuestion(false))
        return stackView
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configure(question: ReadingPartOneQuestion){
//        questionImageView.load(url: url)
        for text in question.questionTexts{
            let label = UILabel.make(text)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(answerButtonsStackView)
        }
        print(stackView.arrangedSubviews)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeFromSuperview()
        questionImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        answerButtonsStackView.addArrangedSubview(trueButton)
//        answerButtonsStackView.addArrangedSubview(falseButton)
        
        contentView.addSubview(questionImageView)
        questionImageView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.7)
        })
        
       
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
