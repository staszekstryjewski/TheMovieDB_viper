//
//  TokenProvider.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import Foundation

protocol TokenProviderProtocol {
    var token: String? { get }
}

struct TokenProvider: TokenProviderProtocol {
    var token: String? {
        Bundle.main.apiToken
    }
}
