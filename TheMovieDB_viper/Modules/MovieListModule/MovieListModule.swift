//
//  MovieListModule.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

protocol ListView: AnyObject {
    func showItems(_ items: [Movie])
    func showError(_ message: String)
}

protocol ListPresenter: AnyObject {
    var view: ListView? { get set }
    var interactor: ListInteractor? { get set }
    var router: ListRouter? { get set }

    func viewDidLoad()
    func didSelectItem(_ item: Movie)
}

protocol ListInteractor:AnyObject {
    var presenter: ListPresenter? { get set }
    func fetchItems() -> [Movie]
}

protocol ListRouter: AnyObject {
    var viewController: UIViewController? { get set }
    func navigateToDetailScreen(with item: Movie)
}

struct MovieListModule {
    private(set) var viewController: MovieListViewController
    private(set) var interactor: MovieListInteractor
    private(set) var presenter: MovieListPresenter
    private(set) var router: MovieListRouter

    static func build() -> MovieListModule {
        let module = MovieListModule(
            viewController: .init(),
            interactor: .init(),
            presenter: .init(),
            router: .init()
        )

        // Strong references
        module.viewController.presenter = module.presenter
        module.presenter.interactor = module.interactor
        module.presenter.router = module.router

        // Weak references
        module.interactor.presenter = module.presenter
        module.presenter.view = module.viewController
        module.router.viewController = module.viewController

        return module
    }
}
