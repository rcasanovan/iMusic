//
//  NetworkTests.swift
//  iMusicTests
//
//  Created by Ricardo Casanova on 23/02/2019.
//  Copyright © 2019 Pijp. All rights reserved.
//

import XCTest
@testable import iMusic

typealias tracksCompletionBlock = (Result<TracksResponse?>) -> Void

class NetworkTests: XCTestCase {
    
    private let requestManager = RequestManager()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTracksResultsWith(search: String? = nil, simulatedJSONFile: String? = nil, completion: @escaping tracksCompletionBlock) {
        var tracksRequest = TracksRequest(search: search)
        
        tracksRequest.completion = completion
        tracksRequest.simulatedResponseJSONFile = simulatedJSONFile
        tracksRequest.verbose = true
        requestManager.send(request: tracksRequest)
    }
    
    func testTracksResults() {
        let tracksResultsExpectation: XCTestExpectation = self.expectation(description: "tracksResultsExpectation")
        
        testTracksResultsWith(search: "Noel Gallagher") { (response) in
            switch response {
            case .success(let response):
                guard let response = response else {
                    XCTFail("Impossible to get the response")
                    return
                }
                XCTAssert(response.results.count != 0, "data array can't be empty")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            tracksResultsExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 25.0, handler: nil)
    }
    
    func testSimulatedTracksResults() {
        let tracksResultsExpectation: XCTestExpectation = self.expectation(description: "tracksResultsExpectation")
        
        testTracksResultsWith(search: "beatles", simulatedJSONFile: "Tracks") { (response) in
            switch response {
            case .success(let response):
                guard let response = response else {
                    XCTFail("Impossible to get the response")
                    return
                }
                XCTAssert(response.results.count != 0, "data array can't be empty")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            tracksResultsExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 25.0, handler: nil)
    }
    
}
