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
    private var isSearchActive: Bool = false

    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.placeholder = "Search"
        $0.searchBar.showsCancelButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTableView()
        startPresenter()
        navigationController?.navigationBar.topItem?.searchController = searchController
        searchController.searchResultsUpdater = self

        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupAppearance() {
        title = "Now playing"
    }

    private func startPresenter() {
        presenter?.createDataSource(tableView: tableView)
        presenter?.fetchNowPlaying()
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
        guard tableView.isDragging else { return }
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

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        isSearchActive = searchController.isActive
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        presenter?.search(for: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard isSearchActive else { return }
        tableView.scrollToRow(at: [0,0], at: .top, animated: false)
        searchBar.resignFirstResponder()
        presenter?.fetchNowPlaying()
    }
}
