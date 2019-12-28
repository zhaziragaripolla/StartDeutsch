//
//  BlankListCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class BlankListCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private var blankDetailCoordinator: BlankDetailCoordinator?
    
    init(presenter: UINavigationController, container: AppDependencyContainer){
        self.container = container
        self.presenter = presenter
    }
    
    func start() {
        let vc = container.makeBlankListViewController()
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension BlankListCoordinator: BlankListViewControllerDelegate{
    func didSelectBlank(detailViewModel: BlankViewModel) {
        let coordinator = BlankDetailCoordinator(presenter: presenter, container: container, viewModel: detailViewModel)
        self.blankDetailCoordinator = coordinator
        coordinator.start()
    }
    
}


