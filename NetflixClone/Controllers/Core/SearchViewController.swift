//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-18.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = [Title]()
    
    // table view
    private let discoverTable: UITableView = {
        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    // search bar controller
    private let searchController: UISearchController = {
        // Creates and returns a search controller with the specified view controller for displaying the results.
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        // search bar
        controller.searchBar.placeholder = "Search for Movie or TV Show"
        // search bar style
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        
        // integrate the search controller onto our naivagation stack
        navigationItem.searchController = searchController
        // bar button item tint color
        navigationController?.navigationBar.tintColor = .systemGray
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscoverMovies()
        
        // responsible for updating the search results for the controller
        searchController.searchResultsUpdater = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    // MARK: - Priavte function
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                // assign the response to the varibale 
                self?.titles = titles
                // reload table view on main thread
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    // data source function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // delegate function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TitleTableViewCell.identifier,
            for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = titles[indexPath.row].title ?? titles[indexPath.row].original_title ?? "Unkown Title"
        guard let posterImage = titles[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: title, posterURL: posterImage))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    // selected movie at index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselct row
        tableView.deselectRow(at: indexPath, animated: true)
        // unwrap optionals
        guard let title = titles[indexPath.row].title ?? titles[indexPath.row].original_title else { return }
        guard let overView = titles[indexPath.row].overview else { return }
        
        // API call
        APICaller.shared.getMovie(with: title) { [weak self] result in
            switch result {
                // success when we have a video
            case .success(let video):
                
                // perform in the main thread
                DispatchQueue.main.async {
                    // create a reference for the preview controller
                    let vc = TitlePreviewViewController()
                    // configure view controller with the view model
                    vc.configure(with: TitlePreviewViewModel(title: title, youtubeiew: video, titleOverview: overView))
                    // push vc
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                // failure print error
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// search conformance
extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {

    
    // update search results
    func updateSearchResults(for searchController: UISearchController) {
        // get query from search bar
        let searchBar = searchController.searchBar
        // query is the text in the search bar
        guard let query = searchBar.text,
              // remove white spaces
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              // call the server when there are at least 3 words in search bar
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              // show search controller
              let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        
        resultController.delegate = self
        
        // call api
        APICaller.shared.search(with: query) { result in
            // perform in the main thread
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
//    SearchResultViewControllerDelegate protocol stub
    func searchResultViewController(_ viewModel: TitlePreviewViewModel) {
        // perfom in main
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
