//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

// MARK: - NetworkRequest

public protocol NetworkRequest {
    typealias CompletionHandler = (NetworkResponse?, Error?) -> Void
    
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var body: Data? { get }
    var responseType: NetworkResponse.Type { get }
    
    func urlRequest(with baseUrl: URL) throws -> URLRequest
}

public extension NetworkRequest {
    var headers: [String : String?]? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    var body: Data? { return nil }
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    func urlRequest(with baseUrl: URL) throws -> URLRequest {
        return try URLRequest.build(from: self, baseUrl: baseUrl)
    }
}

// MARK: - AuthorizedRequest

public protocol AuthorizedRequest : NetworkRequest {
    var authorizationRequirement: AuthorizationRequirement { get }
}

// MARK: - AuthorizationRequirement

public protocol AuthorizationRequirement {
    var authorizationToken: AuthToken { get }
    var httpHeaderValue: String? { get }
}

public extension AuthorizationRequirement {
    var httpHeaderValue: String? { return nil }
}
