//
//  MovieDetailsPresenter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

final class MovieDetailsPresenter: DetailsPresenter {
    weak var view: DetailsView?

    var interactor: DetailsInteractor?
    var router: DetailsRouter?

    @MainActor func viewDidLoad() {
        guard let interactor = interactor else { return }
        Task {
            do {
                let movie = try await interactor.fetch()
                view?.present(movie)
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    @MainActor func didTapStar() {
        guard let interactor = interactor else { return }
        Task {
            do { let movie = try await interactor.toggleFavorite()
                view?.present(movie)
            } catch {
                view?.showError(error.localizedDescription)
            }

        }
    }
}

extension MovieDetailsPresenter: DetailsPresenterToInteractor {}
