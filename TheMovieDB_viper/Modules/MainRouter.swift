//
//  MainRouter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

typealias AppModelDependencies = MovieListModuleDependencies & MovieDetailsModuleDependencies

struct AppDependencies: AppModelDependencies {
    var apiClient: APIClient
    var tokenProvider: TokenProviderProtocol
    var favoritesManager: FavoritesManagerProtocol
    var imageService: ImageProvider

    init(apiClient: APIClient, tokenProvider: TokenProviderProtocol, favoritesManager: FavoritesManagerProtocol, imageService: ImageProvider) {
        self.apiClient = apiClient
        self.tokenProvider = tokenProvider
        self.favoritesManager = favoritesManager
        self.imageService = imageService
    }
}

final class MainRouter<Dependencies>: Dependent where Dependencies: AppModelDependencies {
    let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    func start() -> UIViewController {
        MovieListModule<Dependencies>(dependencies: dependencies).viewController
    }
}
