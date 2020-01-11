//
//  QuestionCellViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/11/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol QuestionCellViewModel {}

protocol CellConfigurable: class {
    func configure(with viewModel: QuestionCellViewModel)
}

