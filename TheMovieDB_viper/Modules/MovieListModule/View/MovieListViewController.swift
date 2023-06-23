//
//  MovieListViewController.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit
import SnapKit

final class MovieListViewController: UIViewController, AlertShowing {
    var presenter: ListPresenter?

    private let tableView = UITableView()
    private var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTableView()
        startPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        tableView.reloadData()
    }

    private func setupAppearance() {
        title = "Now playing"
    }

    private func startPresenter() {
        presenter?.createDataSource(tableView: tableView)
        presenter?.loadMore()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.rowHeight = 80
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.reuseIndentifier)
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        guard indexPath.row == rows - 1, !isLoading else {
            return
        }
        presenter?.loadMore()
    }
}

extension MovieListViewController: ListView {
    func showError(_ message: String) {
        showAlert(message)
    }
}
