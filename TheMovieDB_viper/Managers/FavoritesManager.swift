//
//  FavoritesManager.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import Foundation

protocol FavoritesInfoProviding {
    func isFavorite(id: Int) -> Bool
}

protocol FavoritesManagerProtocol: FavoritesInfoProviding {
    @discardableResult func change(id: Int) -> Bool
}

// TODO: This could probably lead to data races. Consider using actor.
class FavoritesManager: FavoritesManagerProtocol {
    private let favoritesKey: String = "FavoritesManagerStore"

    @discardableResult
    func change(id: Int) -> Bool {
        var favorites = getFavorites()
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }

        saveFavorites(favorites)
        return favorites.contains(id)
    }

    func isFavorite(id: Int) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(id)
    }

    private func getFavorites() -> Set<Int> {
        if let favoritesData = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode(Set<Int>.self, from: favoritesData) {
            return favorites
        }
        return Set<Int>()
    }

    private func saveFavorites(_ favorites: Set<Int>) {
        if let favoritesData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favoritesData, forKey: favoritesKey)
        }
    }
}
