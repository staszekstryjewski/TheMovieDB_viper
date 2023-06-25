//
//  MovieListInteractor.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

typealias MovieListInteractorDependencies = APIClientProviding & FavoritesManagerProviding

final class MovieListInteractor<Dependencies>: ListInteractor, Dependent where Dependencies: MovieListInteractorDependencies{
    weak var presenter: ListPresenter?
    let dependencies: Dependencies

    private var lastEndpoint: APIRouter?
    private var cached: [MovieListModel] = []
    private var currentPage: Int = 1
    private var totalPages: Int = 0

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func fetchMore() async throws -> [MovieListModel] {
        let endpoint: APIRouter = lastEndpoint ?? .nowPlaying()
        if currentPage <= totalPages { currentPage += 1 }

        let models = try await performRequest(endpoint: endpoint.setPage(currentPage))
        cached += models

        return cached
    }

    func searchFor(query: String) async throws -> [MovieListModel] {
        let endpoint = APIRouter.search(query: query).setPage(1)
        let models = try await performRequest(endpoint: endpoint)
        cached = models
        return cached
    }

    func fetchNowPlaying() async throws -> [MovieListModel] {
        let endpoint = APIRouter.nowPlaying().setPage(1)
        let models = try await performRequest(endpoint: endpoint)
        cached = models
        return cached
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favoritesManager.isFavorite(id: id)
    }

    func toggleFavorite(_ id: Int) async throws -> [MovieListModel] {
        favoritesManager.change(id: id)
        if let index = cached.firstIndex(where: { $0.id == id }) {
            let toggled = cached[index]
            let isFavorite = favoritesManager.isFavorite(id: id)
            let copy = MovieListModel(id: id, title: toggled.title, favorite: isFavorite)
            cached[index] = copy
        }
        return cached
    }

    private func performRequest(endpoint: APIRouter) async throws -> [MovieListModel] {
        lastEndpoint = endpoint
        let response: APIResponse = try await apiClient.get(endpoint: endpoint)
        currentPage = response.page
        totalPages = response.totalPages
        return try await mapModel(response)
    }

    private func mapModel(_ response: APIResponse) async throws -> [MovieListModel] {
        response.results.map {
            let isFavorite = favoritesManager.isFavorite(id: $0.id)
            return MovieListModel(
                id: $0.id,
                title: $0.title,
                favorite: isFavorite
            )
        }
    }

}
