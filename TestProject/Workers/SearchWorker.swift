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
    func performSearch(searchText: String, completion: Optional<() -> ()>)
    
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
    
    func performSearch(searchText: String,
                       completion: Optional<() -> ()>) {
        guard !searchText.isEmpty else {
            resetSearch()
            return
        }
        
        execute(on: .global()) {
            let searchResult = self.getSearchResults(text: searchText)
            execute(on: .main) {
                self.searchResult = searchResult
                completion?()
            }
        }
    }
    
    func resetSearch() { searchResult = dataSource }
    
    func sorted(dataSource: [CityData]) -> [CityData] {
        return dataSource.sorted {
            $0.name != $1.name
                ? $0.name < $1.name
                : $0.country < $1.country
        }
    }
}

private extension SearchWorker {
    func getSearchResults(text: String) -> [CityData] {
        let (cities, countries) = (
            dataSource.filter {
                $0.name
                    .lowercased()
                    .hasPrefix(text.lowercased())
            },
            dataSource.filter {
                $0.country
                    .lowercased()
                    .hasPrefix(text.lowercased())
            }
        )
        return cities + countries
    }
}
