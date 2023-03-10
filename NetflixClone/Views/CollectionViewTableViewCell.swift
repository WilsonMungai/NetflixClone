//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-20.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDelegate(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    // Initialze variable that holds the titles
    private var titles: [Title] = [Title]()
    
    // MARK: - Private functions
    // anonymous closure to create collection view cell
    private let collectionView: UICollectionView = {
        // Creates a grid of items with optional header
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    // Set up frame
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Initializer
    // Initialize the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Title configure
    public func configre(with title: [Title]) {
        self.titles = title
        // since the title data is being retrieved in an async method, we need to reload the data inside the main thread
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - Private functions
    // MARK: - Core Data
    private func downloadTitleAt(indexPath: IndexPath) {
//        print("downloading\(titles[indexPath.row].title)")
        DataPersistenceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            switch result {
            case .success():
                // notify the listeners when the download is complete
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("downloaded to database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // return the number of movies
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    // the conetnt that will be shown in the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .green
        
        // deque the ttile collection view cell model
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
                                                            for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        // Unwrap poster path
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
    
    // register when cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // deselect the item selected
        collectionView.deselectItem(at: indexPath, animated: true)
        // unwrap title
        guard let title = titles[indexPath.row].title ?? titles[indexPath.row].original_title else { return }
        
        // appending trailer to the movie title will return the movie's trailer
        APICaller.shared.getMovie(with: title + " trailer") { [weak self] result in
            switch result {
            case .success(let video):
                // unwrap overview
                let overView = self?.titles[indexPath.row]
                guard let titleOverview = overView?.overview else {
                    return
                }
                
                let viewModel = TitlePreviewViewModel(title: title,
                                                      youtubeiew: video,
                                                      titleOverview: titleOverview)
                // unwrap the option table view cell
                guard let strongSelf = self else { return }
                self?.delegate?.collectionViewTableViewCellDelegate(strongSelf, viewModel: viewModel)
                // get the movie id
//                print(video.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // asks collection view for menu context for the selected item
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          subtitle: nil,
                                          image: nil,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
//                print("downloading")
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
 
