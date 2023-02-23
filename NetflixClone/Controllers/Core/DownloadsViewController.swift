//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-18.
//

import UIKit

class DownloadsViewController: UIViewController {

    // initialize property of type items saved in database
    private var titles: [TitleItem] = [TitleItem]()
    // table view
    private let downloadedTable: UITableView = {
        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        view.addSubview(downloadedTable)
        fetchStoredData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    
    // MARK: - Private functions
    private func fetchStoredData() {
        print("fetching")
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extension
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    // data source functio
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = titles.count
//        print("Epiosdes are: \(count)")
        return count
    }

    // delegate function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
//        cell.textLabel?.text = upComing[indexPath.row].original_title ?? upComing[indexPath.row].title ?? "Unkown"
        let upComingTitles = titles[indexPath.row].original_title ?? titles[indexPath.row].title ?? "Unkown"
        // unwrapping image view
        guard let upComingPoster = titles[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(titleName: upComingTitles , posterURL: upComingPoster))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // asks the database to delete or insert an item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // switch on editing style
        switch editingStyle {
        case .delete:
            // delete from the database
            DataPersistenceManager.shared.deletetitle(model: titles[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // remove the item that has been deleted from the array
            titles.remove(at: indexPath.row)
            // delete the row
            downloadedTable.deleteRows(at: [indexPath], with: .fade)
        default: break
        }
    }
}
