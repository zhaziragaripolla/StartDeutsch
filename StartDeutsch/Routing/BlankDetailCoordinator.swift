//
//  BlankDetailCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class BlankDetailCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private let viewModel: BlankViewModel
    
    init(presenter: UINavigationController, container: AppDependencyContainer, viewModel: BlankViewModel){
        self.container = container
        self.presenter = presenter
        self.viewModel = viewModel
    }
    
    func start() {
        let vc = container.makeBlankDetailViewController(viewModel: viewModel)
//        presenter.modalPresentationStyle = .fullScreen
//        presenter.present(vc, animated: true, completion: nil)
        presenter.pushViewController(vc, animated: true)
    }
    
}
