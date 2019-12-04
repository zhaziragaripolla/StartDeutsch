//
//  LocalCollection.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 11/20/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import FirebaseFirestore

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
//    associatedtype Rictionary: Dictionary<String, Any>
    init?(dictionary: [String: Any], path: String)
}

//final class LocalCollection<T: DocumentSerializable> {
//
//  private(set) var items: [T]
//  private(set) var documents: [DocumentSnapshot] = []
//  let query: Query
//
//  private let updateHandler: ([DocumentChange]) -> ()
//
//  private var listener: ListenerRegistration? {
//    didSet {
//      oldValue?.remove()
//    }
//  }
//
//  var count: Int {
//    return self.items.count
//  }
//
//  subscript(index: Int) -> T {
//    return self.items[index]
//  }
//
//  init(query: Query, updateHandler: @escaping ([DocumentChange]) -> ()) {
//    self.items = []
//    self.query = query
//    self.updateHandler = updateHandler
//  }
//
//  func index(of document: DocumentSnapshot) -> Int? {
//    return documents.firstIndex(where: { $0.documentID == document.documentID })
//  }
//
//  func listen() {
//    guard listener == nil else { return }
//    listener = query.addSnapshotListener { [unowned self] querySnapshot, error in
//      guard let snapshot = querySnapshot else {
//        print("Error fetching snapshot results: \(error!)")
//        return
//      }
//      let models = snapshot.documents.map { (document) -> T in
//        if let model = T(dictionary: document.data()) {
//          return model
//        } else {
//          // handle error
//          fatalError("Unable to initialize type \(T.self) with dictionary \(document.data())")
//        }
//      }
//      self.items = models
//      self.documents = snapshot.documents
//      self.updateHandler(snapshot.documentChanges)
//    }
//  }
//
//  func stopListening() {
//    listener = nil
//  }
//
//  deinit {
//    stopListening()
//  }
//}
