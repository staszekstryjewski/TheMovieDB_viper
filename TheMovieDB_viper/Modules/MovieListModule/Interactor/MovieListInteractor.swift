//
//  MovieListInteractor.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

final class MovieListInteractor: ListInteractor {
    weak var presenter: ListPresenter?

    func fetchItems() -> [Movie] {
        [Movie(title: "1"), Movie(title: "2")]
    }
}
