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
    case search(query: String, page: Int? = nil)

    private static let defaultMoviePath = "/3/movie"
    private enum PathKey: String {
        case language, region, page, query
    }

    var scheme: String {
        "https"
    }

    // We could provide this values from a Config/plist file to handle prod/dev servers.
    var host: String {
        switch self {
        case .nowPlaying, .movieDetails, .search:
            return "api.themoviedb.org"
        case .image:
            return "image.tmdb.org"
        }
    }

    var path: String {
        switch self {
        case .nowPlaying(_):
            return "\(APIRouter.defaultMoviePath)/now_playing"
        case .movieDetails(let id):
            return "\(APIRouter.defaultMoviePath)/\(id)"
        case .search(_, _):
            return "/3/search/movie"
        case .image(let path, let sizeClass):
            return "/t/p/\(sizeClass)/\(path)"
        }
    }

    var method: String {
        switch self {
        case .nowPlaying, .movieDetails, .search:
            return "GET"
        case .image:
            return "GET"
        }
    }
    
    var language: String {
        "pl-PL"
    }

    var region: String {
        "PL"
    }


    func setPage(_ page: Int?) -> APIRouter {
        switch self {
        case .nowPlaying:
            return .nowPlaying(page: page)
        case .search(let query, _):
            return .search(query: query, page: page)
        case .movieDetails, .image:
            return self
        }
    }

    private func getPage() -> Int? {
        switch self {
        case .nowPlaying(let page), .search(_, let page):
            return page
        default:
            return nil
        }
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

        if case let .search(query, _) = self {
            let queryItem = URLQueryItem(name: PathKey.query.rawValue, value: query)
            urlComponents.queryItems?.append(queryItem)
        }

        if let page = getPage() {
            let queryItem = URLQueryItem(name: PathKey.page.rawValue, value: String(page))
            urlComponents.queryItems?.append(queryItem)
        }

        let url = urlComponents.url!

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
}
