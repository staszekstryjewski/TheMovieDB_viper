//
//  Dependencies.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import Foundation

protocol APIClientProviding {
    var apiClient: APIClient { get }
}

extension Dependent where Dependencies: APIClientProviding {
    var apiClient: APIClient { dependencies.apiClient }
}

protocol FavoritesManagerProviding {
    var favoritesManager: FavoritesManagerProtocol { get }
}

extension Dependent where Dependencies: FavoritesManagerProviding {
    var favoritesManager: FavoritesManagerProtocol { dependencies.favoritesManager }
}

protocol ImageServiceProviding {
    var imageService: ImageProvider { get }
}

extension Dependent where Dependencies: ImageServiceProviding {
    var imageService: ImageProvider { dependencies.imageService}
}
