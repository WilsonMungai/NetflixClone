//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-18.
//

import UIKit

class UpcomingViewController: UIViewController {

    // Initialze array of title as empty array
    private var upComing: [Title] = [Title]()

    // table view
    private let upComingTable: UITableView = {
        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upComingTable)

        upComingTable.delegate = self
        upComingTable.dataSource = self

        fetchUpComing()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTable.frame = view.bounds
    }

    // MARK: - Private Functions
    private func fetchUpComing() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let upComing):
                self?.upComing = upComing
                // perform in the main thread
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    // data source functio
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = upComing.count
//        print("Epiosdes are: \(count)")
        return count
    }

    // delegate function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
//        cell.textLabel?.text = upComing[indexPath.row].original_title ?? upComing[indexPath.row].title ?? "Unkown"
        let upComingTitles = upComing[indexPath.row].original_title ?? upComing[indexPath.row].title ?? "Unkown"
        // unwrapping image view
        guard let upComingPoster = upComing[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: upComingTitles , posterURL: upComingPoster))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
