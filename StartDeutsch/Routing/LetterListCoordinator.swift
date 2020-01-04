//
//  LetterListCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class LetterListCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private var letterDetailCoordinator: LetterDetailCoordinator?
    
    init(presenter: UINavigationController, container: AppDependencyContainer){
        self.container = container
        self.presenter = presenter
    }
    
    func start() {
        let vc = container.makeLetterListViewController()
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension LetterListCoordinator: LetterListViewControllerDelegate{
    func didSelectLetter(detailViewModel: LetterViewModel) {
        let coordinator = LetterDetailCoordinator(presenter: presenter, container: container, viewModel: detailViewModel)
        self.letterDetailCoordinator = coordinator
        coordinator.start()
    }
    
}
