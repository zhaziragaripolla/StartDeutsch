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
        case "E0DB28E3-E5DD-4300-BE1F-7FA060D03629": // listening
            coordinator = ListeningCourseCoordinator(presenter: presenter, container: container, test: test)
            self.listeningCourseCoordinator = coordinator as? ListeningCourseCoordinator
        case "7122B041-2CAA-440B-9D51-A124F6059B3F":  // reading
            coordinator = ReadingCourseCoordinator(presenter: presenter, container: container, test: test)
            self.readingCourseCoordinator = coordinator as? ReadingCourseCoordinator
        default: break
        }
        coordinator?.start()
    }
}
