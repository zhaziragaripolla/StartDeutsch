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
    private let testId: String
    
    init(presenter: UINavigationController, container: AppDependencyContainer, testId: String){
        self.container = container
        self.presenter = presenter
        self.testId = testId
    }
    
    func start() {
        let vc = container.makeListeningCourseViewController(testId: testId)
        presenter.pushViewController(vc, animated: true)
    }
    
}
