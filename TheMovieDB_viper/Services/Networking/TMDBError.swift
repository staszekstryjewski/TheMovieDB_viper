//
//  TMDBError.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

public enum TMDbError: Error {
    case network(Error)
    case badReponse(Int?)
    case decode(Error)
    case unauthorized
    case unknown
}
