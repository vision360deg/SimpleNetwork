//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : String?]

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
    
    public var rawValue: String {
        return String(describing: self).uppercased()
    }
}

public enum HTTPStatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case timeout = 408
    case conflict = 409
    case lengthRequired = 411
    case unprocessable = 422
    case tooManyRequests = 429
    case general = 500
    case notImplemented = 501
    case badGateway = 502
    case unavailable = 503
}

extension HTTPStatusCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized Request"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Resource Not Found"
        case .methodNotAllowed:
            return "Method Not Allowed"
        case .notAcceptable:
            return "Request Not Acceptable"
        case .timeout:
            return "Timeout"
        case .conflict:
            return "Conflict"
        case .lengthRequired:
            return "Length Required"
        case .unprocessable:
            return "Request Unprocessable"
        case .tooManyRequests:
            return "Too Many Requests"
        case .general:
            return "Internal Server Error"
        case .notImplemented:
            return "Not Implemented"
        case .badGateway:
            return "Bad Gateway"
        case .unavailable:
            return "Unavailable"
        }
    }
}
