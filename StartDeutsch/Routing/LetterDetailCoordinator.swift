//
//  LetterDetailCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/29/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LetterDetailCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private let viewModel: LetterViewModel
    
    init(presenter: UINavigationController, container: AppDependencyContainer, viewModel: LetterViewModel){
        self.container = container
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let vc = container.makeLetterDetailViewController(viewModel: viewModel)
//        presenter.modalPresentationStyle = .fullScreen
//        presenter.present(vc, animated: true, completion: nil)
        presenter.pushViewController(vc, animated: true)
    }
    
}
