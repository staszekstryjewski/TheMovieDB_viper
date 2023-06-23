//
//  APIRouter.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

protocol Endpoint {
    func asURLRequest() -> URLRequest
}

enum APIRouter: Endpoint {
    case nowPlaying(page: Int? = nil)
    case movieDetails(id: Int)
    case image(path: String, sizeClass: String)

    private static let defaultMoviePath = "/3/movie"
    private enum PathKey: String {
        case language, region, page
    }

    var scheme: String {
        "https"
    }

    // We could provide this values from a Config/plist file to handle prod/dev servers.
    var host: String {
        switch self {
        case .nowPlaying(_), .movieDetails(_):
            return "api.themoviedb.org"
        case .image(_, _):
            return "image.tmdb.org"
        }
    }

    var path: String {
        switch self {
        case .nowPlaying(_):
            return "\(APIRouter.defaultMoviePath)/now_playing"
        case .movieDetails(let id):
            return "\(APIRouter.defaultMoviePath)/\(id)"
        case .image(let path, let sizeClass):
            return "/t/p/\(sizeClass)/\(path)"
        }
    }

    var method: String {
        switch self {
        case .nowPlaying(_), .movieDetails(_):
            return "GET"
        case .image(_, _):
            return "GET"
        }
    }
    
    var language: String {
        "pl-PL"
    }

    var region: String {
        "PL"
    }

    func asURLRequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path

        urlComponents.queryItems = [
            .init(name: PathKey.language.rawValue, value: language),
            .init(name: PathKey.region.rawValue, value: region),
        ]

        if case let .nowPlaying(page) = self,
           let unwrapped = page {
            let queryItem = URLQueryItem(name: PathKey.page.rawValue, value: String(unwrapped))
            urlComponents.queryItems?.append(queryItem)
        }

        let url = urlComponents.url!

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
}
