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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        print("Epiosdes are: \(count)")
        return count
    }

    // delegate function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        guard let title = titles[indexPath.row].original_name else { return UITableViewCell() }
        cell.textLabel?.text = upComing[indexPath.row].original_title ?? upComing[indexPath.row].title ?? "Unkown"
        return cell
    }
}
