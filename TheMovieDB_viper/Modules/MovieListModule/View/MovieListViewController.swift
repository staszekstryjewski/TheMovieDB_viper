//
//  MovieListViewController.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

final class MovieListViewController: UITableViewController {
    private let cellId = "cell"
    var presenter: ListPresenter?
    
    private var items: [Movie] = []

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        presenter?.viewDidLoad()
    }
}

extension MovieListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        presenter?.didSelectItem(item)
    }
}

extension MovieListViewController: ListView {
    func showItems(_ items: [Movie]) {
        self.items = items
        tableView.reloadData()
    }

    func showError(_ message: String) {
        print("ERRROR:", message)
    }
}
