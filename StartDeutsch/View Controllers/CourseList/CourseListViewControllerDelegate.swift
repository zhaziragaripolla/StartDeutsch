//
//  CourseListViewControllerDelegate.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/30/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

protocol CourseListViewControllerDelegate: class {
    func didSelectCourse(course: Course)
}
