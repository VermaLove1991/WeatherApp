//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Apple on 10/28/21.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    private let viewModel = WeatherViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let promise = expectation(description: "Status code: 200")

        viewModel.fetchForcastAPI {
            promise.fulfill()
        } failure: { error in
            print(error)
        }
    }
}
