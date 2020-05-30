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
    private var readingCourseCoordinator: ReadingCourseCoordinator?
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
    
    func didSelectTest(test: Test) {
        var coordinator: Coordinator?
        switch test.courseId {
        case "a2336bc7-ba54-4d8e-a13b-62458be238b8": // listening
            coordinator = ListeningCourseCoordinator(presenter: presenter, container: container, test: test)
            self.listeningCourseCoordinator = coordinator as? ListeningCourseCoordinator
        case "30c83904-d711-4833-bb5a-df86978ea2f2":  // reading
            coordinator = ReadingCourseCoordinator(presenter: presenter, container: container, test: test)
            self.readingCourseCoordinator = coordinator as? ReadingCourseCoordinator
        default: break
        }
        coordinator?.start()
    }
}
