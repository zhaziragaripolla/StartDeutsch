//
//  CourseListCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/30/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class CourseListCoordinator: Coordinator {
    private var presenter: UINavigationController
    private let container: AppDependencyContainer
    private var testListCoordinator: TestListCoordinator?

    init(presenter: UINavigationController, container: AppDependencyContainer) {
        self.presenter = presenter
        self.container = container
    }
    
    func start() {
        let vc = container.makeCoursesViewController()
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }

}

extension CourseListCoordinator: CourseListViewControllerDelegate {
    func didSelectCourse(courseId: Int) {
        let coordinator = TestListCoordinator(presenter: presenter, container: container, courseId: courseId)
        self.testListCoordinator = coordinator
        coordinator.start()
    }
}
