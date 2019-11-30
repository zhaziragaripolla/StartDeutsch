//
//  TestListCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/30/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class TestListCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private var listeningCourseCoordinator: ListeningCourseCoordinator?
    private let courseId: Int
    
    init(presenter: UINavigationController, container: AppDependencyContainer, courseId: Int){
        self.container = container
        self.presenter = presenter
        self.courseId = courseId
    }
    
    func start() {
        let vc = container.makeTestsViewController(courseId: courseId)
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension TestListCoordinator: TestListViewControllerDelegate {
    // TODO: according test.courseId choose Listening/Reading/Writing/Speaking
    func didSelectTest(testId: String) {
        let coordinator = ListeningCourseCoordinator(presenter: presenter, container: container, testId: testId)
        self.listeningCourseCoordinator = coordinator
        coordinator.start()
    }
}


