//
//  MovieListPresenter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

final class MovieListPresenter: ListPresenter {
    weak var view: ListView?
    
    var interactor: ListInteractor?
    var router: ListRouter?

    func viewDidLoad() {
        guard let items = interactor?.fetchItems() else {
            view?.showError("Error fetching")
            return
        }
        view?.showItems(items)
    }

    func didSelectItem(_ item: Movie) {
        router?.navigateToDetailScreen(with: item)
    }

}
