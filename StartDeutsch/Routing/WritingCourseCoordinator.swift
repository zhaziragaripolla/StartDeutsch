//
//  WritingCourseCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 12/27/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class WritingCourseCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController, container: AppDependencyContainer){
        self.container = container
        self.presenter = presenter
    }
    
    func start() {
        let vc = container.makeWritingCourseViewController()
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension WritingCourseCoordinator: WritingCourseViewControllerDelegate{
    func didSelectWritingPartOne() {
        let coordinator = BlankListCoordinator(presenter: presenter, container: container)
        coordinator.start()
    }
    
    func didSelectWritingPartTwo() {
        let coordinator = LetterListCoordinator(presenter: presenter, container: container)
        coordinator.start()
    }
    
}
