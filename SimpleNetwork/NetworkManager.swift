//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

// MARK: - NetworkManager

open class NetworkManager: NSObject {
    
    public let configuration: NetworkConfiguration
    private lazy var urlSession = URLSession(
        configuration: configuration.urlSessionConfiguration,
        delegate: configuration.urlSessionDelegate ?? DefaultNetworkDelegate(),
        delegateQueue: configuration.urlSessionDelegateOperationQueue)
    
    open var baseUrl: URL {
        return configuration.host
    }
    
    public init(configuration config: NetworkConfiguration) {
        configuration = config
        super.init()
    }
    
    /// - Note: The session object keeps a strong reference to the delegate
    ///         until your app exits or explicitly invalidates the session.
    ///         If you do not invalidate the session by calling the invalidateAndCancel()
    ///         or finishTasksAndInvalidate() method, your app leaks memory until it exits.
    deinit {
        urlSession.finishTasksAndInvalidate()
    }
    
    open func send(_ request: NetworkRequest,
              completion: @escaping NetworkRequest.CompletionHandler) throws
    {
        let dataTask = try urlSession.dataTask(
            with: request,
            baseUrl: baseUrl,
            completionHandler: completion)
        dataTask.resume()
    }
}

public final class DefaultNetworkDelegate: NSObject, URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        logSessionTaskError(error)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        logSessionTaskError(error)
    }
    private func logSessionTaskError(_ error: Error?) {
        debugPrint(#file, #function, error?.localizedDescription ?? "")
    }
}

// MARK: - NetworkError

public enum NetworkError: Error {
    /// The response was not received before the timeout occurred.
    case requestDidTimeout
    /// There is no available connection to the server.
    case noConnection
    /// Typically refers to an internal error; XRequest expects, XResponse.
    case unexpectedResponse
    /// The response was not received.
    case noResponse
    /// Holds server error messages intended for user presentation.
    case descriptiveServerError(String)
    /// Holds the HTTPStatusCode type, `.descriptiveServerError` is preferred over `.httpError` when possible.
    case httpError(HTTPStatusCode)
    /// Holds the raw Int HTTP Status Code.
    case httpRawError(Int)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestDidTimeout:
            return "Request did timeout"
        case .noConnection:
            return "The Internet connection appears to be offline"
        case .unexpectedResponse:
            return "Unexpected response"
        case .noResponse:
            return "No response"
        case .descriptiveServerError(let message):
            return message
        case .httpError(let httpStatusCode):
            return httpStatusCode.description
        case .httpRawError(let rawStatusCode):
            return "HTTP status code \(rawStatusCode)"
        }
    }
}
