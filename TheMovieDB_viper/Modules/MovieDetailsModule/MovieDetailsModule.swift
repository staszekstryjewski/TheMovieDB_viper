//
//  MovieDetailsModule.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

protocol DetailsView: AnyObject {
    func present(_ item: MovieDetailsModel)
    func showError(_ message: String)
}

protocol DetailsPresenter: AnyObject {
    var view: DetailsView? { get set }
    var interactor: DetailsInteractor? { get set }
    var router: DetailsRouter? { get set }

    func viewDidLoad()
    func didTapStar()
}

protocol DetailsPresenterToInteractor: AnyObject {}

protocol DetailsInteractor: AnyObject {
    var presenter: DetailsPresenterToInteractor? { get set }
    func fetch() async throws -> MovieDetailsModel
    func toggleFavorite() async throws -> MovieDetailsModel
}

protocol DetailsRouter: AnyObject {
    var viewController: UIViewController? { get set }
}

typealias MovieDetailsModuleDependencies = APIClientProviding & FavoritesManagerProviding & ImageServiceProviding

struct MovieDetailsModule<Dependencies>: Dependent where Dependencies: MovieDetailsModuleDependencies {

    private(set) var viewController: MovieDetailsViewController
    private let interactor: MovieDetailsInteractor<Dependencies>
    private let presenter: MovieDetailsPresenter
    private let router: MovieDetailsRouter

    let dependencies: Dependencies

    init(id: Int, dependencies: Dependencies) {
        self.dependencies = dependencies

        self.viewController = .init()
        self.interactor = .init(dependencies: dependencies, id: id)
        self.presenter = .init()
        self.router = .init()

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
