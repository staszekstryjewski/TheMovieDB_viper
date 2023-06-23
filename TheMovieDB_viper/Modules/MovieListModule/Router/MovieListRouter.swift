//
//  MovieListRouter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

typealias MovieListRouterDependencies = MovieDetailsModuleDependencies

final class MovieListRouter<Dependencies>: ListRouter, Dependent where Dependencies: MovieListRouterDependencies {
    weak var viewController: UIViewController?
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func navigateToDetailScreen(with id: Int) {
        let module = MovieDetailsModule(id: id, dependencies:  dependencies)
        guard let navigation = viewController?.navigationController else {
            fatalError("missing navigation...")
        }
        navigation.pushViewController(module.viewController, animated: true)
    }
}
