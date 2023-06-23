//
//  Bundle+Config.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import Foundation

extension Bundle {
    var apiToken: String? {
        info(for: "THEMOVIEDB_ACCESS_TOKEN")
    }

    func info(for key: String) -> String? {
        object(forInfoDictionaryKey: key) as? String
    }
}
