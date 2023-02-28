//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-22.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewController(_ viewModel: TitlePreviewViewModel)
}

// Responsible for displaying the search results
class SearchResultViewController: UIViewController {

    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        
        // layout that arranges items in a grid view with optional header and footer for each section
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        // spacing between items in the row
        layout.minimumInteritemSpacing = 0
        
        // collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
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
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: TitleCollectionViewCell.identifier,
//            for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
                                                            for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        
        // unwrap movie poster
//        guard let posterPath = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
//        cell.configure(with: posterPath)
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
//        cell.backgroundColor = .systemGray
        return cell
    }
    
    // register item selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // unrwap optionals
        guard let title = titles[indexPath.row].title ?? titles[indexPath.row].original_title else { return }
        guard let overView = titles[indexPath.row].overview else { return }
        
        
        // API call
        APICaller.shared.getMovie(with: title) { [weak self] result in
            switch result {
                // success when we have a video
            case .success(let video):
                // protocol
                self?.delegate?.searchResultViewController(TitlePreviewViewModel(title: title,
                                                                           youtubeiew: video,
                                                                           titleOverview: overView))
                // failure print error
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
