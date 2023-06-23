//
//  MovieDetailsInteractor.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

typealias MovieDetailsInteractorDependencies = APIClientProviding & FavoritesManagerProviding & ImageServiceProviding

final class MovieDetailsInteractor<Dependencies>: DetailsInteractor, Dependent where Dependencies: MovieDetailsInteractorDependencies {

    struct MovieDetailsInteractorError: LocalizedError {
        var errorDescription: String? {
            "Something went wrong...\nPlease try again"
        }
    }
    weak var presenter: DetailsPresenterToInteractor?

    private var cachedModel: MovieDetailsModel?

    private let id: Int
    let dependencies: Dependencies

    init(dependencies: Dependencies, id: Int) {
        self.dependencies = dependencies
        self.id = id
    }

    func fetch() async throws -> MovieDetailsModel {
        let response: MovieModel = try await apiClient.get(endpoint: APIRouter.movieDetails(id: id))
        var image = UIImage()
        if let path = response.backdropPath {
            image = try await getImage(with: path)
        }
        let isFavorite = favoritesManager.isFavorite(id: id)

        let rating = String(format: "%.1f (%d votes)", response.voteAverage, response.voteCount)
        let model = MovieDetailsModel(
            title: response.title,
            date: response.releaseDate,
            rating: rating,
            overview: response.overview,
            favorite: isFavorite,
            image: image
        )
        cachedModel = model
        return model
    }

    func toggleFavorite() async throws -> MovieDetailsModel {
        guard var model = cachedModel else {
            throw MovieDetailsInteractorError()
        }
        model.favorite = favoritesManager.change(id: id)
        return model
    }

    private func getImage(with name: String) async throws -> UIImage {
        try await imageService.getImage(name: name, size: .w500)
    }

    private func isFavorite(_ item: MovieListModel) -> Bool {
        favoritesManager.isFavorite(id: Int(item.id))
    }
}
