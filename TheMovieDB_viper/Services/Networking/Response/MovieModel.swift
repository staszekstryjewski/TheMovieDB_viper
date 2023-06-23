//
//  MovieModel.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import Foundation

public struct MovieModel: Codable {
    public let backdropPath: String?
    public let id: Int
    public let overview: String
    public let releaseDate: String
    public let title: String
    public let voteAverage: Double
    public let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id = "id"
        case overview = "overview"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    public init(
        backdropPath: String?,
        id: Int,
        overview: String,
        releaseDate: String, title: String,
        voteAverage: Double, voteCount: Int
    ) {
        self.backdropPath = backdropPath
        self.id = id
        self.overview = overview
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
