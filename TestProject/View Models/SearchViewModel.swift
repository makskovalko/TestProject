//
//  SearchViewModel.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

//MARK: - Search ViewModel Definition

protocol SearchViewModelOperations {
    init(worker: SearchWorker, router: SearchRouter<SearchView>)
    
    subscript(index: Int) -> CityData { get }
    
    var searchResult: [CityData] { get }
    var count: Int { get }
    
    mutating func loadDataArray()
    mutating func performSearch(searchText: String)
    
    func resetSearch()
    func showMapView(forIndex index: Int, presentationContext: SearchView)
}

//MARK: - Search ViewModel Implementation

struct SearchViewModel: SearchViewModelOperations {
    private let searchWorker: SearchWorker
    private let router: SearchRouter<SearchView>
    
    var cities: [CityData] {
        return searchWorker.dataSource
    }
    
    var searchResult: [CityData] {
        return searchWorker.searchResult
    }
    
    var count: Int { return searchResult.count }
    
    subscript(index: Int) -> CityData {
        return searchResult[index]
    }
    
    init(worker: SearchWorker, router: SearchRouter<SearchView>) {
        self.searchWorker = worker
        self.router = router
    }
    
    mutating func loadDataArray() {
        searchWorker.loadDataSource()
    }
    
    mutating func performSearch(searchText: String) {
        searchWorker.performSearch(searchText: searchText)
    }
    
    func resetSearch() { searchWorker.resetSearch() }
}

//MARK: - Routing

extension SearchViewModel {
    func showMapView(forIndex index: Int, presentationContext: SearchView) {
        router.showMapView(
            presentationContext: presentationContext,
            data: searchResult[index]
        )
    }
}
