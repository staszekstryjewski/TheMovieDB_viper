//
//  FavoritesManager.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import Foundation

protocol FavoritesManagerProtocol {
    @discardableResult func change(id: Int) -> Bool
    func isFavorite(id: Int) -> Bool
}

class FavoritesManager: FavoritesManagerProtocol {
    private let favoritesKey: String = "DiskFavoritesManagerStore"
    private let favoritesFileURL: URL

    private let favoritesQueue = DispatchQueue(label: "com.theMovieDB_viper.favoritesQueue")

    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        favoritesFileURL = documentsDirectory.appendingPathComponent(favoritesKey).appendingPathExtension("plist")
    }

    @discardableResult
    func change(id: Int) -> Bool {
        favoritesQueue.sync {
            var favorites = getFavorites()
            if favorites.contains(id) {
                favorites.remove(id)
            } else {
                favorites.insert(id)
            }
            saveFavorites(favorites)
        }

        return isFavorite(id: id)
    }

    func isFavorite(id: Int) -> Bool {
        var isFavorite = false
        favoritesQueue.sync {
            let favorites = getFavorites()
            isFavorite = favorites.contains(id)
        }
        return isFavorite
    }

    private func getFavorites() -> Set<Int> {
        if let favoritesData = try? Data(contentsOf: favoritesFileURL),
           let decodedFavorites = try? PropertyListDecoder().decode(Set<Int>.self, from: favoritesData) {
            return decodedFavorites
        }
        return Set<Int>()
    }

    private func saveFavorites(_ favorites: Set<Int>) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary

        if let favoritesData = try? encoder.encode(favorites) {
            try? favoritesData.write(to: favoritesFileURL, options: .atomic)
        }
    }
}
