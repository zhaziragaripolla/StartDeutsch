//
//  CoreDataRepositoryTests.swift
//  StartDeutschTests
//
//  Created by Zhazira Garipolla on 5/14/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import XCTest
import CoreData
import Combine
@testable import Start_Deutsch

class CoreDataRepositoryTests: XCTestCase {
    
    var sut: CoreDataRepository<Course>!
    var initialStubsCount: Int!

    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    func createStubs(count: Int) {
        func insertCourse(id: String){
            let obj = NSEntityDescription.insertNewObject(forEntityName: "ManagedCourse", into: mockPersistantContainer.viewContext)
            obj.setValue(id, forKey: "id")
            obj.setValue("newTitle", forKey: "title")
            obj.setValue("newTitle", forKey: "documentPath")
            obj.setValue("newTitle", forKey: "aliasName")
            obj.setValue("newTitle", forKey: "descriptionText")
        }

        for i in 1...5{
            insertCourse(id: "id\(i)")
        }
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("Initializaing fake stubs. Error: \(error)")
        }
    }
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Course", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )
                                            
                if let error = error {
                    fatalError("Create an in-mem coordinator failed \(error)")
                }
            }
            return container
    }()
    
    override func setUp() {
        super.setUp()
        sut = CoreDataRepository<Course>(container: mockPersistantContainer)
        initialStubsCount = 5
        createStubs(count: initialStubsCount)
    }

    override func tearDown() {
        sut = nil
        deleteStubs()
        initialStubsCount = nil
        super.tearDown()
    }

    func testRepo_whenInsertItem_incrementsCount(){
        // given
        let course = Course(title: "Title", id: UUID().description, aliasName: "", description: "description")
        
        // when
        sut.insert(item: course)
        
        // then
        XCTAssertEqual(numberOfItemsInPersistentStore(), initialStubsCount + 1)
    }
    
    func testRepo_whenGetItem_returnAllItems(){
        // given
        let finishExpectation = expectation(description: "asynchronous call finished")
        let countExpectation = expectation(description: "desirable number of items")
        
        // when
        let _ = getCourse(where: nil).sink(receiveCompletion: { result in
            switch result {
            case .finished:
                finishExpectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { courses in
            if courses.count == 5 {
                countExpectation.fulfill()
            }
        })
        
        // then
        waitForExpectations(timeout: 1)
    }
  
    func testRepo_whenGetItemWithPredicate_returnOneItem(){
        // given
        let finishExpectation = expectation(description: "asynchronous call finished")
        let itemExpectation = expectation(description: "desirable number of items")
        
        // when
        let _ = getCourse(where: ["id":"id1"]).sink(receiveCompletion: { result in
            switch result {
            case .finished:
                finishExpectation.fulfill()
            case .failure(let error):
                XCTFail("Error happened when getting an item. Error: \(error)")
            }
        }, receiveValue: { courses in
            if let course = courses.first, course.id == "id1"{
                itemExpectation.fulfill()
            }
        })
        
        // then
        waitForExpectations(timeout: 1)
    }
    
    func testRepo_whenDeleteItem_decrementsCount(){
        // given
        var course: Course!
        var _ = getCourse(where: nil)
            .sink(receiveCompletion: {_ in
            }, receiveValue: { courses in
                course = courses.first
            })
        
        // when
        guard course != nil else {
           XCTFail("No course to be deleted")
            return
        }
        
        sut.delete(item: course)
        
        // then
        XCTAssertEqual(numberOfItemsInPersistentStore(), initialStubsCount - 1)
    }
    
    
    func testRepo_whenNoData_returnsError(){
        // given
        deleteStubs()
        let errorExpectation = expectation(description: "Expecting Error: No data")
        
        // when
        let _ = getCourse(where: ["nonExsitingKey":"nonExsitingValue"])
            .sink(receiveCompletion: { result in
                switch result{
                    case .failure(let error):
                        if let error = error as? CoreDataError, error == CoreDataError.noData{
                            errorExpectation.fulfill()
                        }
                    case .finished:
                        XCTFail("Finished unexpectedly.")
                }
            }, receiveValue: { _ in })
        
        // then
        waitForExpectations(timeout: 1)
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ManagedCourse")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
    func getCourse(where parameters: Dictionary<String, Any>?)->Future<[Course], Error>{
        return sut.getAll(where: parameters)
    }
    
    func deleteStubs() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedCourse")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
}
