//
//  Cache.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

protocol Cache {
    associatedtype T
    func store(_ object: T, for key: String)
    func get(for key: String) -> T?
}

/// Worth implementing in the future. Maybe like a storage service of some kind.
class ImageCache: Cache {
    func store(_ object: UIImage, for key: String) {}
    func get(for key: String) -> UIImage? { nil }
}
