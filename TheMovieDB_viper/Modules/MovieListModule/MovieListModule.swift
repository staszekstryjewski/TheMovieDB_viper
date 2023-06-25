//
//  MovieListModule.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

protocol ListView: AnyObject {
    func showError(_ message: String)
}

protocol ListPresenter: AnyObject {
    var view: ListView? { get set }
    var interactor: ListInteractor? { get set }
    var router: ListRouter? { get set }
    func loadMore()
    func didSelectItem(at indexPath: IndexPath)
    func createDataSource(tableView: UITableView)
    func search(for query: String)
    func fetchNowPlaying()
}

protocol ListInteractor: AnyObject {
    var presenter: ListPresenter? { get set }
    func fetchMore() async throws -> [MovieListModel]
    func toggleFavorite(_ id: Int) async throws -> [MovieListModel]
    func searchFor(query: String) async throws -> [MovieListModel]
    func fetchNowPlaying() async throws -> [MovieListModel]
    func isFavorite(_ id: Int) -> Bool
}

protocol ListRouter: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToDetailScreen(with id: Int)
}

typealias MovieListModuleDependencies = APIClientProviding & FavoritesManagerProviding & MovieListRouterDependencies

struct MovieListModule<Dependencies>: Dependent where Dependencies: MovieListModuleDependencies {

    private(set) var viewController: MovieListViewController
    private let interactor: MovieListInteractor<Dependencies>
    private let presenter: MovieListPresenter
    private let router: MovieListRouter<Dependencies>

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        viewController = .init()
        interactor = .init(dependencies: dependencies)
        presenter = .init()
        router =  .init(dependencies: dependencies)

        // Strong references
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router

        // Weak references
        interactor.presenter = presenter
        presenter.view = viewController
        router.viewController = viewController
    }
}
