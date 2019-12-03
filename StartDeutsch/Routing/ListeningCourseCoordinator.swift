//
//  ListeningCourseCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/30/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ListeningCourseCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private let test: Test
    
    init(presenter: UINavigationController, container: AppDependencyContainer, test: Test){
        self.container = container
        self.presenter = presenter
        self.test = test
    }
    
    func start() {
        let vc = container.makeListeningCourseViewController(test: test)
        presenter.pushViewController(vc, animated: true)
    }
    
}
