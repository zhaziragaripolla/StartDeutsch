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
    private var writingCourseCoordinator: WritingCourseCoordinator?

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
    func didSelectCourse(course: Course) {
        switch course.aliasName {
        case "writing":
            let coordinator = WritingCourseCoordinator(presenter: presenter, container: container)
            self.writingCourseCoordinator = coordinator
            coordinator.start()
        default:
            let coordinator = TestListCoordinator(presenter: presenter, container: container, course: course)
            self.testListCoordinator = coordinator
            coordinator.start()
        }
    }
}
