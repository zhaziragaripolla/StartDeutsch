//
//  WordListCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class WordListCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController, container: AppDependencyContainer){
        self.container = container
        self.presenter = presenter
    }
    
    func start() {
        let vc = container.makeWordListViewController()
        presenter.pushViewController(vc, animated: true)
    }
    
}
