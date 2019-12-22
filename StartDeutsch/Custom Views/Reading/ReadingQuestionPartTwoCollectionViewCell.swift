//
//  ReadingQuestionPartTwoCollectionViewCell.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/22/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingQuestionPartTwoCollectionViewCell: UICollectionViewCell {
    
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
    
    private var imageListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageListStackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(questionLabel)
        questionLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(15)
            make.trailing.leading.equalToSuperview()
        })
        
        addSubview(imageListStackView)
        imageListStackView.snp.makeConstraints({ make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.8)
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


