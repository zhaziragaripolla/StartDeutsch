//
//  ReadingCourseCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/19/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class ReadingCourseCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private let test: Test
    
    init(presenter: UINavigationController, container: AppDependencyContainer, test: Test){
        self.container = container
        self.presenter = presenter
        self.test = test
    }
    
    func start() {
        let vc = container.makeReadingCourseViewController(test: test)
        presenter.pushViewController(vc, animated: true)
    }
    
}

