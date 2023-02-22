//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-18.
//

import UIKit

// handles the different cases
enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitle: [String] = ["Trending Movies", "Trending Tv",  "Popular", "Upcoming Movies", "Top Rated"]
    
    // anonymous closur pattern
    // table view
    private let homeFeedTable: UITableView = {
        // initialize table
        // frame is zero coz the frame is defined in view did layout subview
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        
        configureNavBar()
        
        // Setup the header view
        let heederView = HeroHeaderUIView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height/2))
        homeFeedTable.tableHeaderView = heederView
        
//        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // layouts the table view to the screen bounds
        homeFeedTable.frame = view.bounds
        
//        homeFeedTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width,                    height:view.bounds.height/2))
    }
    
    // MARK: - Private methodd
    // Navigation buttons
    private func configureNavBar() {
        var image = UIImage(named: "logo")
        // renders the ios system to use image as it is
        image = image?.withRenderingMode(.alwaysOriginal)
        
        // left Bar ButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        // right Bar ButtonItem
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.circle"), style: .done, target: self, action: nil)
        ]
        
        // change navigation bar tint
        navigationController?.navigationBar.tintColor = .systemGray
    }
    
//    private func fetchData() {
//        APICaller.shared.getTrendingMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        APICaller.shared.getTrendingTv { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getUpcomingMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getPopularMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        APICaller.shared.getTopRatedMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }

//    }
}

// MARK: - Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // return sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // return number of rows inside section 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // delegate method that tells the table view which cell is being dequed for each row
    // initialize which cell is being dequed for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        // switch on the indexpath to get the selected item
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            // API Caller to get trending movies
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case .success(let titles):
                    cell.configre(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            // API Caller to get trending tv
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let titles):
                    cell.configre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // API Caller to get popular movies
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // API Caller to get upcoming movies
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configre(with: titles)
//                    print(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // API Caller to get top rated movies
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default: return UITableViewCell()
        }
        return cell
    }
    
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
    }
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // header section
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter() // capitalized 
//        header.textLabel?.textColor = .systemBackground
    }
    
    // return the title in each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    // tells the delegate when the user scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // offset of the top inset of the screen
        let defaultOffSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffSet
        // when the user scrolls the naviagtion bar moves up
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
