//
//  NetworkManager.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 1/22/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import Foundation
import Reachability

class MulticastDelegate<T> {

    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects.reversed() {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }

    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}

protocol NetworkManagerDelegate: class{
    func reachabilityChanged(_ isReachable: Bool)
}

protocol NetworkManagerProtocol: class{
    func networkStatusChanged(_ notification: Notification)
    func stopNotifier()
    func isReachable()-> Bool
}

class NetworkManager: NetworkManagerProtocol {

    private var reachability: Reachability!
    let multicast = MulticastDelegate<NetworkManagerDelegate>()

    init(_ delegates: [NetworkManagerDelegate]) {
        // Initialize delegates
        delegates.forEach({ multicast.add($0)})
        
        // Initialise reachability
        reachability = try? Reachability()

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        if reachability.connection == .unavailable {
            multicast.invoke{ $0.reachabilityChanged(false) }
        }
        else {
            multicast.invoke{ $0.reachabilityChanged(true) }
        }
    }
    
    func addDelegate(_ delegate: NetworkManagerDelegate){
        multicast.add(delegate)
    }

    func stopNotifier() -> Void {
        // Stop the network status notifier
        reachability.stopNotifier()
    }

    // Network is reachable
    func isReachable()-> Bool{
        if reachability.connection != .unavailable {
            return true
        }
        return false
    }

    // Network is unreachable
    func isUnreachable()-> Bool {
        if reachability.connection == .unavailable {
            return true
        }
        return false
    }

}
