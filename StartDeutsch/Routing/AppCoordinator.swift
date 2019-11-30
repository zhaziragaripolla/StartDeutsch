//
//  AppCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/30/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var courseListCoordinator: CourseListCoordinator
    var container: AppDependencyContainer
    
    init(window: UIWindow, container: AppDependencyContainer) {
        self.window = window
        self.container = container
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
        courseListCoordinator = CourseListCoordinator(presenter: rootViewController, container: container)
    }
    
    func start() {
        window.rootViewController = rootViewController
        courseListCoordinator.start()
        window.makeKeyAndVisible()
    }
    
}


