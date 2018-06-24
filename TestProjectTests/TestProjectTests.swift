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
        
        searchWorker.dataSource = testDataSource
        searchWorker.performSearch(searchText: "Ala")
        
        XCTAssertEqual(searchWorker.searchResult.count, 2)
        
        searchWorker.performSearch(searchText: "Ams")
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
        ]
        
        searchWorker.performSearch(searchText: "A")
        
        XCTAssertTrue(searchWorker.searchResult.last?.country == "AU")
        XCTAssertEqual(searchWorker.searchResult.count, 5)
        
        searchWorker.performSearch(searchText: "S")
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
        
        viewModel.performSearch(searchText: "Ams")
        XCTAssertTrue(viewModel.searchResult.isEmpty)
        
        searchWorker.dataSource = testDataSource
        viewModel.performSearch(searchText: "Ams")
        XCTAssertFalse(viewModel.searchResult.isEmpty)
        
        XCTAssertEqual(searchWorker.searchResult.count, viewModel.count)
        viewModel.performSearch(searchText: "London")
        XCTAssertTrue(viewModel.searchResult.isEmpty)
    }
}
