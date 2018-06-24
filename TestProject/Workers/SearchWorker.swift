//
//  SearchWorker.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

//MARK: - Search Operations

protocol SearchOperations {
    associatedtype DataSource
    
    var dataSource: [DataSource] { get set }
    var searchResult: [DataSource] { get set }
    
    init(loader: DataSourceLoader)
    
    func loadDataSource()
    func performSearch(searchText: String)
    func resetSearch()
    func sorted(dataSource: [DataSource]) -> [DataSource]
}

//MARK: - Search Implementation

final class SearchWorker: SearchOperations {
    var dataSource: [CityData] = []
    var searchResult: [CityData] = []
    
    private let dataSourceLoader: DataSourceLoader
    
    init(loader: DataSourceLoader) {
        self.dataSourceLoader = loader
    }
    
    func loadDataSource() {
        self.dataSource = dataSourceLoader.loadArray() |> sorted
        self.searchResult = dataSource
    }
    
    func performSearch(searchText: String) {
        guard !searchText.isEmpty else {
            resetSearch()
            return
        }
        
        searchResult = dataSource
            .filter { $0.name.hasPrefix(searchText)
                || $0.country.hasPrefix(searchText) }
            |> sorted
    }
    
    func resetSearch() { searchResult = dataSource }
    
    func sorted(dataSource: [CityData]) -> [CityData] {
        return dataSource.sorted { $0.name != $1.name
            ? $0.name < $1.name
            : $0.country < $1.country
        }
    }
}
