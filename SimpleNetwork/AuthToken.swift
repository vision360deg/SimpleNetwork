//
//  SimpleNetwork.h
//  SimpleNetwork
//
//  Created by Federico on 11/8/19.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import Foundation

// MARK: - AuthToken

public protocol AuthToken {
    var rawValue: String { get }
    var token: String? { get }
    var expiration: Date? { get }
    init?(rawValue rVal: String)
}
