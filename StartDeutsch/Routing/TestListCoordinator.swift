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
    private let course: Course
    
    init(presenter: UINavigationController, container: AppDependencyContainer, course: Course){
        self.container = container
        self.presenter = presenter
        self.course = course
    }
    
    func start() {
        let vc = container.makeTestsViewController(course: course)
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension TestListCoordinator: TestListViewControllerDelegate {
    // TODO: according test.courseId choose Listening/Reading/Writing/Speaking
    func didSelectTest(test: Test) {
        let coordinator = ListeningCourseCoordinator(presenter: presenter, container: container, test: test)
        self.listeningCourseCoordinator = coordinator
        coordinator.start()
    }
}


