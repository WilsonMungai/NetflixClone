//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-22.
//

import UIKit

// Responsible for displaying the search results
class SearchResultViewController: UIViewController {

    public var titles: [Title] = [Title]()
    
    public let searchResultCollectionView: UICollectionView = {
        
        // layout that arranges items in a grid view with optional header and footer for each section
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        // spacing between items in the row
        layout.minimumInteritemSpacing = 0
        
        // collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultCollectionView)
        view.backgroundColor = .systemBackground
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    // notify view views have been laid iut
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = titles.count
//        print("Search result is \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TitleCollectionViewCell.identifier,
            for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        // unwrap movie poster
        guard let posterPath = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: posterPath)
//        cell.backgroundColor = .systemGray
        return cell
    }
}
