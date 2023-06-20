//
//  MovieListRouter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

final class MovieListRouter: ListRouter {
    weak var viewController: UIViewController?

    func navigateToDetailScreen(with item: Movie) {
        print("navigate to:", item.title)
    }
}
