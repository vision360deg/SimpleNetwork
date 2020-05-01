//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

fileprivate extension String {
    static let authorization = "Authorization"
}

fileprivate extension URL {
    
    enum BuildError: String, Error {
        case unableToParseUrl
        case unableToParseComponents
    }
    
    func appendingPercentEncodedQueryItemComponents(_ queryItems: [URLQueryItem]?) throws -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw BuildError.unableToParseComponents
        }
        urlComponents.percentEncodedQueryItems = queryItems
        guard let url = urlComponents.url else { throw BuildError.unableToParseUrl }
        return url
    }
}

extension URLRequest {

    /// Builds a `URLRequest` instance given a `NetworkRequest` description and a base `URL` for the server
    static func build(from request: NetworkRequest, baseUrl: URL) throws -> URLRequest {
        var result = try URLRequest(from: request, baseUrl: baseUrl)
        result.httpMethod = request.httpMethod.rawValue
        if let authorizedRequest = request as? AuthorizedRequest {
            let token = authorizedRequest.authorizationRequirement.authorizationToken
            let headerValue = authorizedRequest.authorizationRequirement.httpHeaderValue
            result.setValue(headerValue ?? token.rawValue, forHTTPHeaderField: .authorization)
        }
        request.headers?.forEach { result.setValue($1, forHTTPHeaderField: $0) }
        result.httpBody = request.body
        return result
    }
    
    /// Initalizes a `URLRequest` from a `NetworkRequest`
    /// - Note: if the `request` parameter contains any url paramenters,
    ///         these will be added to the returned `URLRequest`
    private init(from request: NetworkRequest, baseUrl: URL) throws {
        var url = baseUrl
        if !request.path.isEmpty {
            url = url.appendingPathComponent(request.path)
        }
        url = try url.appendingPercentEncodedQueryItemComponents(request.queryItems)
        self.init(url: url, cachePolicy: request.cachePolicy)
    }
}

extension URLSession {
    /// Returns a `URLSessionDataTask` given a `NetworkRequest`,
    /// a base `URL`, and a `NetworkRequest.CompletionHandler`
    func dataTask(with request: NetworkRequest,
                  baseUrl: URL,
                  completionHandler: @escaping NetworkRequest.CompletionHandler) throws -> URLSessionDataTask
    {
        /// Intercepts the `Data`, the `URLResponse`, and the `Error`,
        /// and forwards them to the `NetworkRequest.CompletionHandler`
        func handleResponse(data: Data?, urlResponse: URLResponse?, error: Error?) {
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                handleUnavailableHTTPURLResponse(error, completionHandler)
                return
            }
            do {
                let response = try request.responseType.init(data: data, httpURLResponse: httpResponse)
                guard request.responseType == type(of: response) else {
                    let error = NetworkError.unexpectedResponse
                    debugPrint(error)
                    completionHandler(response, error)
                    return
                }
                completionHandler(response, error)
            } catch let parseResponseError {
                debugPrint(parseResponseError)
                let failureResponse = try? FailureResponse(data: data, httpURLResponse: httpResponse)
                completionHandler(failureResponse, parseResponseError)
            }
        }
        let urlRequest = try request.urlRequest(with: baseUrl)
        return dataTask(with: urlRequest, completionHandler: handleResponse)
    }
    
    private func handleUnavailableHTTPURLResponse(_ error: Error?,
                                                  _ completionHandler: @escaping NetworkRequest.CompletionHandler)
    {
        guard let error = error else {
            completionHandler(nil, NetworkError.noResponse)
            return
        }
        debugPrint(error)
        let nsError = error as NSError
        guard nsError.domain == NSURLErrorDomain else {
            completionHandler(nil, error)
            return
        }
        if nsError.code == -1001 {
            completionHandler(nil, NetworkError.requestDidTimeout)
            return
        }
        if nsError.code == -1009 {
            completionHandler(nil, NetworkError.noConnection)
            return
        }
        completionHandler(nil, error)
    }
}
