//
//  ViewController.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

protocol SearchView {
    var viewModel: SearchViewModel { get set }
}

class SearchViewController: UIViewController, SearchView {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    var viewModel = SearchViewModel(
        worker: SearchWorker(
            loader: JSONLoader(
                fileName: "cities",
                type: "json")),
        router: SearchRouter()
    ) { didSet { tableView.reloadData() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureSearchBar()
        
        viewModel.loadDataArray()
    }
    
    private func configureTableView() {
        let configure = {
            $0.dataSource = self
            $0.delegate = self
            $0.tableFooterView = UIView()
            $0.keyboardDismissMode = .onDrag
            $0.register(
                UITableViewCell.self,
                forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
            )
        } as (UITableView) -> Void
        configure(tableView)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }

}

//MARK: - TableView DataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(UITableViewCell.self)) else { fatalError() }
        cell.textLabel?.text = viewModel[indexPath.row].description
        return cell
    }
}

//MARK: - TableView Delegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showMapView(
            forIndex: indexPath.row,
            presentationContext: self
        )
    }
}

//MARK: - SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(searchText: searchText)
    }
}
