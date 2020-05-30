//
//  ViewModelDelegates.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/26/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation

protocol ListeningViewModelDelegate: class {
    func didDownloadAudio(path: URL)
}

protocol UserAnswerDelegate: class {
    func didCheckUserAnswers(result: Int)
}
