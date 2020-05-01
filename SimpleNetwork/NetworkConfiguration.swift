//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

// MARK: - NetworkConfiguration

public protocol NetworkConfiguration {
    var host: URL { get }
    var managementHost: URL? { get }
    var urlSessionConfiguration: URLSessionConfiguration { get }
    var urlSessionDelegate: URLSessionDelegate? { get }
    var urlSessionDelegateOperationQueue: OperationQueue? { get }
}

public extension NetworkConfiguration {
    var managementHost: URL? { return nil }
    var urlSessionConfiguration: URLSessionConfiguration { return .default }
    var urlSessionDelegate: URLSessionDelegate? { return nil }
    var urlSessionDelegateOperationQueue: OperationQueue? { return .main }
}
