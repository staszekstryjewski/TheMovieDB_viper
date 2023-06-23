//
//  ImageService.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

protocol ImageProvider {
    func getImage(name: String, size: ImageSizeClass) async throws -> UIImage
}

enum ImageSizeClass {
    case original, w500

    var path: String {
        switch self {
        case .original:
            return "/original"
        case .w500:
            return "/w500"
        }
    }
}

final class ImageService: ImageProvider {
    private let apiClient: APIClient
    private let cache: ImageCache

    init(apiClient: APIClient, cache: ImageCache) {
        self.apiClient = apiClient
        self.cache = cache
    }

    func getImage(name: String, size: ImageSizeClass = .original) async throws -> UIImage {
        let key = size.path + name
        if let image: UIImage = cache.get(for: key) {
            return image
        }
        do {
            let imageData: Data = try await apiClient.getData(endpoint: APIRouter.image(path: name, sizeClass: size.path))
            if let image = UIImage(data: imageData) {
                cache.store(image, for: key)
                return image
            } else {
                throw NSError(domain: "", code: -2)
            }
        } catch {
            throw error
        }
    }
}
