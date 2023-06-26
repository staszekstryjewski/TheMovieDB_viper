//
//  Dependent.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import Foundation

protocol Dependent {
    associatedtype Dependencies
    var dependencies: Dependencies { get }
}
