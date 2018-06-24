//
//  TestProjectTests.swift
//  TestProjectTests
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import XCTest
@testable import TestProject

class TestProjectTests: XCTestCase {
    
    var testDataSource: [CityData] = []
    
    override func setUp() {
        super.setUp()
        
        testDataSource = [
            CityData(_id: 0,
                     country: "US",
                     name: "Alabama",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "US",
                     name: "Alaska",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "AU",
                     name: "Sydney",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "US",
                     name: "Amsterdam",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "NL",
                     name: "Amsterdam",
                     coord: .init(lon: 0, lat: 0))
        ]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataSourceLoader() {
        let loader = JSONLoader(
            fileName: "cities",
            type: "json"
        )
        
        let searchWorker = SearchWorker(loader: loader)
        
        XCTAssertTrue(searchWorker.dataSource.isEmpty)
        searchWorker.loadDataSource()
        XCTAssertTrue(!searchWorker.dataSource.isEmpty)
    }
    
    func testSearchLogic() {
        let searchWorker = SearchWorker(
            loader: JSONLoader(
                fileName: "cities",
                type: "json"
            )
        )
        
        searchWorker.dataSource = testDataSource |> searchWorker.sorted
        
        var searchExpectation = expectation(description: "Perform search")
        searchWorker.performSearch(searchText: "Ala") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        
        XCTAssertEqual(searchWorker.searchResult.count, 2)
        XCTAssertTrue(searchWorker.searchResult.first?.country == "US")
        
        searchExpectation = expectation(description: "Perform search")
        searchWorker.performSearch(searchText: "Ams") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        XCTAssertTrue(searchWorker.searchResult.first?.country == "NL")
        
        searchWorker.dataSource = [
            CityData(_id: 0,
                     country: "US",
                     name: "Alabama",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "US",
                     name: "Albuquerque",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "AU",
                     name: "Sydney",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "US",
                     name: "Anaheim",
                     coord: .init(lon: 0, lat: 0)),
            CityData(_id: 0,
                     country: "US",
                     name: "Arizona",
                     coord: .init(lon: 0, lat: 0))
        ] |> searchWorker.sorted
        
        searchExpectation = expectation(description: "Perform search")
        searchWorker.performSearch(searchText: "A") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        XCTAssertTrue(searchWorker.searchResult.last?.country == "AU")
        XCTAssertEqual(searchWorker.searchResult.count, 5)
        
        searchExpectation = expectation(description: "Perform search")
        searchWorker.performSearch(searchText: "S") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        XCTAssertEqual(searchWorker.searchResult.count, 1)
        XCTAssertTrue(searchWorker.searchResult.last?.country == "AU")
    }
    
    func testSearchViewModel() {
        let searchWorker = SearchWorker(
            loader: JSONLoader(
                fileName: "cities",
                type: "json"
            )
        )
        
        var viewModel = SearchViewModel(
            worker: searchWorker,
            router: SearchRouter<SearchView>()
        )
        
        var searchExpectation = expectation(description: "Perform search")
        
        viewModel.performSearch(searchText: "Ams") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        
        XCTAssertTrue(viewModel.searchResult.isEmpty)
        searchWorker.dataSource = testDataSource
        
        searchExpectation = expectation(description: "Perform search")
        viewModel.performSearch(searchText: "Ams") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        XCTAssertFalse(viewModel.searchResult.isEmpty)
        
        XCTAssertEqual(searchWorker.searchResult.count, viewModel.count)
        
        searchExpectation = expectation(description: "Perform search")
        viewModel.performSearch(searchText: "London") {
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 0.1)
        XCTAssertTrue(viewModel.searchResult.isEmpty)
    }
}
