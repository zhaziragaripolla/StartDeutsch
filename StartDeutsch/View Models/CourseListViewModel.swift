//
//  CourseListViewModel.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Reachability
import os

protocol ViewModelDelegate: class {
    func didDownloadData()
    func networkOffline()
    func networkOnline()
    func didStartLoading()
    func didCompleteLoading()
}

class CourseListViewModel {
    // Models
    public var courses: [Course] = []
    
    //Delegates
    weak var delegate: ViewModelDelegate?
    weak var errorDelegate: ErrorDelegate?
    
    // Dependencies
    private let firebaseManager: FirebaseManagerProtocol
    private let repository: CoreDataRepository<Course>
    private let networkManager: NetworkManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol, repository: CoreDataRepository<Course>, networkManager: NetworkManagerProtocol){
        self.firebaseManager = firebaseManager
        self.repository = repository
        self.networkManager = networkManager
    }

    public func getCourses(){
        os_log("Started to fetch data")
        fetchFromLocalDatabase()
        if courses.isEmpty {
            os_log("Checking internet connection")
            if !networkManager.isReachable(){
                os_log("Device is online")
                self.delegate?.networkOffline()
            }
            else {
                os_log("Device is offline")
            }
        }
        else {
            os_log("Data is fethed from Core Data")
            delegate?.didDownloadData()
        }
    }
    
    private func fetchFromLocalDatabase(){
        do {
            courses = try repository.getAll(where: nil)
            os_log("Call to Core Data, found %d elements", courses.count)
        }
        catch let error {
            print(error)
            fetchFromRemoteDatabase()
        }
    }
    
    private func fetchFromRemoteDatabase(){
        delegate?.didStartLoading()
        firebaseManager.getDocuments("/courses") { result in
            switch result {
            case .success(let response):
                self.courses = response.map({ return Course(dictionary: $0.data(), path: $0.reference.path)!})
                self.delegate?.didDownloadData()
                self.saveToLocalDatabase()
                self.delegate?.didCompleteLoading()
                os_log("Data is fethed from Firebase")
            case .failure(let error):
                if let message = error.errorDescription {
                    self.errorDelegate?.showError(message: "Code: \(error.code). \(message)")
                }
                self.delegate?.didCompleteLoading()
            }
        }
    }
    
    private func saveToLocalDatabase(){
        courses.forEach({
            repository.insert(item: $0)
        })
    }

}

extension CourseListViewModel: NetworkManagerDelegate{
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            os_log("Change of intenet connection. Device is online.")
            self.delegate?.networkOnline()
            if courses.isEmpty {
                fetchFromRemoteDatabase()
            }
        }
        else {
            os_log("Change of intenet connection. Device is offline.")
            if courses.isEmpty {
                self.delegate?.networkOffline()
            }
        }
    }
}

