//
//  MovieListPresenter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

//@MainActor
final class MovieListPresenter: ListPresenter {
    weak var view: ListView?

    var interactor: ListInteractor?
    var router: ListRouter?

    private enum Section {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, MovieListModel>?

    func createDataSource(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Section, MovieListModel>(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIndentifier, for: indexPath) as! MovieListCell
            let copy = MovieListModel(id: itemIdentifier.id, title: itemIdentifier.title, favorite: self?.interactor?.isFavorite(itemIdentifier.id) ?? false)
            cell.fill(with: copy)
            cell.didTapButton = { [weak self] in
                self?.toggleFavorite(itemIdentifier.id)
            }
            return cell
        }
    }

    func loadMore() {
        guard let interactor = interactor else { return }
        Task {
            do {
                let items = try await interactor.fetchMore()
                updateSnapshot(with: items, withAnimation: false)
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    func fetchNowPlaying() {
        guard let interactor = interactor else { return }
        Task {
            do {
                let items = try await interactor.fetchNowPlaying()
                updateSnapshot(with: items, withAnimation: false)
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    func search(for query: String) {
        guard let interactor = interactor else { return }
        Task {
            do {
                let items = try await interactor.searchFor(query: query)
                updateSnapshot(with: items, withAnimation: false)
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        router?.navigateToDetailScreen(with: item.id)
    }

    func toggleFavorite(_ id: Int) {
        guard let interactor = interactor else { return }
        Task {
            do {
                let items = try await interactor.toggleFavorite(id)
                updateSnapshot(with: items, withAnimation: false)
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    private func updateSnapshot(with items: [MovieListModel], withAnimation: Bool) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteAllItems()
        if !snapshot.sectionIdentifiers.contains(.main) {
                snapshot.appendSections([.main])
            }
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: withAnimation)
    }
}
