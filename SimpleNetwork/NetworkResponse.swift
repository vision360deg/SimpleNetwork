//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

// MARK: - NetworkResponse

public protocol NetworkResponse {
    var httpURLResponse: HTTPURLResponse { get }
    var isHTTPStatusCodeSuccessful: Bool { get }
    init(data: Data?, httpURLResponse response: HTTPURLResponse) throws
}

public extension NetworkResponse {
    var isHTTPStatusCodeSuccessful: Bool { httpURLResponse.statusCode < 400 }
}

// MARK: - InitError

public enum InitError: String, Error { case noData, invalidData }

// MARK: - FailureResponse

public struct FailureResponse: NetworkResponse {
    public let httpURLResponse: HTTPURLResponse
    public let data: Data?
    public init(data: Data?, httpURLResponse response: HTTPURLResponse) throws {
        httpURLResponse = response
        self.data = data
    }
}
