//
//  NetworkMonitor.swift
//  CititesMap
//
//  Created by Sara Eltlt on 09/08/2023.
//

import Foundation
import Network

class NetworkMonitor {
    // MARK: - singleton object creation
    static let shared = NetworkMonitor()
    private init() {}

    // MARK: - variables
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    private var statusChangeHandler: ((Bool) -> Void)?

    public private(set) var isConnected = false {
        didSet {
            statusChangeHandler?(isConnected)
        }
    }

    // MARK: - connection monitoring
    public func startMonitoring(statusChangeHandler: @escaping (Bool) -> Void) {
        self.statusChangeHandler = statusChangeHandler
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {
                return
            }
            self.isConnected = path.status != .unsatisfied
        }
    }
    public func stopMonitoring() {
        monitor.cancel()
    }

}

