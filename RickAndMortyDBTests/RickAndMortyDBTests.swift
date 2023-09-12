//
//  RickAndMortyDBTests.swift
//  RickAndMortyDBTests
//
//  Created by Kanghos on 2023/09/03.
//

import XCTest
@testable import RickAndMortyDB

final class RickAndMortyDBTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
      let expectation = XCTestExpectation(description: "api test")
      let session = URLSession.shared
      let request = RequestWithPath(
        base: RequestWithURL(url: URL(string: Constant.baseURLString)!),
        path: [EndPoint.character.rawValue]).request()
      session.perform(request) { result in
        switch result {
        case .success(let success):
          print(success.1.statusCode)
          expectation.fulfill()
        case .failure(let failure):
          print(failure)
          expectation.fulfill()
        }
      }
      wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
