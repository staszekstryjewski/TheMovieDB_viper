//
//  Movie.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

struct MovieListModel: Hashable {
    let id: Int
    let title: String
    let favorite: Bool
    private let uuid = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
