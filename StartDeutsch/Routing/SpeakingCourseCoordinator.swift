//
//  SpeakingCourseCoordinator.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/5/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import UIKit

class SpeakingCourseCoordinator: Coordinator {
    
    private let container: AppDependencyContainer
    private let presenter: UINavigationController
    private var wordListCoordinator: WordListCoordinator?
    private var cardListCoordinator: CardListCoordinator?
    
    init(presenter: UINavigationController, container: AppDependencyContainer){
        self.container = container
        self.presenter = presenter
    }
    
    func start() {
        let vc = container.makeSpeakingCourseViewController()
        vc.delegate = self
        presenter.pushViewController(vc, animated: true)
    }
    
}

extension SpeakingCourseCoordinator: SpeakingCourseViewControllerDelegate{
    func didSelectSpeakingPartOne() {
        // TODO: add coordinator settings
    }
    
    func didSelectSpeakingPartTwo() {
        let coordinator = WordListCoordinator(presenter: presenter, container: container)
        self.wordListCoordinator = coordinator
        coordinator.start()
    }
    
    func didSelectSpeakingPartThree() {
        let coordinator = CardListCoordinator(presenter: presenter, container: container)
        self.cardListCoordinator = coordinator
        coordinator.start()
    }

}

