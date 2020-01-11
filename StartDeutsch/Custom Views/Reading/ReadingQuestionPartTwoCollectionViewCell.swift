//
//  ReadingQuestionPartTwoCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingQuestionPartTwoCollectionViewCell: UICollectionViewCell {
    
    // Used for assigning a tag for generated buttons.
    var indexCounter = 0
    
    weak var delegate: ReadingQuestionDelegate?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private var answerImageView: UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    var firstImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.setTitle("First", for: .normal)
        return button
    }()
    
    var secondImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.setTitle("Second", for: .normal)
        return button
    }()
    
    private var answerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var imageListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    @objc func didTapAnswerButton(_ sender: UIButton){
        delegate?.didSelectSignleAnswer(cell: self, answer: sender.tag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageListStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRandomGradient()
        
        firstImageButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        secondImageButton.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        answerButtonsStackView.addArrangedSubview(firstImageButton)
        answerButtonsStackView.addArrangedSubview(secondImageButton)

        contentView.addSubview(imageListStackView)
        imageListStackView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.9)
        })
        
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalTo(imageListStackView.snp.top).offset(-10)
        })
        
        contentView.addSubview(answerButtonsStackView)
        answerButtonsStackView.snp.makeConstraints({ make in
            make.top.equalTo(imageListStackView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview().offset(-10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReadingQuestionPartTwoCollectionViewCell: CellConfigurable{
    func configure(with viewModel: QuestionCellViewModel) {
        guard let model = viewModel as? ReadingPartTwoViewModel else {return}
        questionLabel.text = model.questionText
        for url in model.imageUrls{
            let imageView = answerImageView
            imageView.load(url: url)
            imageListStackView.addArrangedSubview(imageView)
        }
    }
}


