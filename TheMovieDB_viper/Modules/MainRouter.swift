//
//  MainRouter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

final class MainRouter {
    func start() -> UIViewController {
        MovieListModule.build().viewController
    }
}
