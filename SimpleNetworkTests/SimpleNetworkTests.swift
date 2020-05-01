//
//  SimpleNetworkTests.swift
//  SimpleNetworkTests
//
//  Created by Federico on 4/15/20.
//  Copyright © 2020 FedericoPaliotta. All rights reserved.
//

import XCTest
@testable import SimpleNetwork

class SimpleNetworkTests: XCTestCase {
    
    struct TestRequest: NetworkRequest {
        let path: String = "/"
        let httpMethod: HTTPMethod = .get
        let responseType: NetworkResponse.Type = TestResponse.self
        init() {}
    }
    
    struct TestResponse: NetworkResponse {
        let httpURLResponse: HTTPURLResponse
        init(data: Data?, httpURLResponse response: HTTPURLResponse) throws {
            self.httpURLResponse = response
            print(#file, #function, data ?? "no data")
            guard (200..<300).contains(response.statusCode) else {
                let error = HTTPStatusCode(rawValue: response.statusCode)!
                throw NetworkError.httpError(error)
            }
        }
    }
    
    struct TestNetworkConfiguration: NetworkConfiguration {
        let host = URL(string: "http://www.apple.com")!
    }
    
    let networkManager = NetworkManager(configuration: TestNetworkConfiguration())
    
    func testExampleGetRequest() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        
        try! networkManager.send(TestRequest()){ testResponse, error in
            XCTAssertNotNil(testResponse, "No data was downloaded.")
            XCTAssertNil(error)
            print(#file, #function, testResponse ?? "no response")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

