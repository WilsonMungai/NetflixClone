//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-18.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // layouts the table view to the screen bounds
        homeFeedTable.frame = view.bounds
        
        homeFeedTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2))
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // Return sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
