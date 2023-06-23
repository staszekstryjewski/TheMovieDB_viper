//
//  SceneDelegate.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let dependencies = AppDependencies()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = MainRouter(dependencies: dependencies).start()
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}

private extension AppDependencies {
    init() {
        let tokenProvider = TokenProvider()
        let client = TMDBClient(
            session: .shared,
            serializer: .init(decoder: .init()),
            tokenProvider: tokenProvider)
        let cache = ImageCache()
        self.tokenProvider = tokenProvider
        self.apiClient = client

        self.favoritesManager = FavoritesManager()
        self.imageService = ImageService(apiClient: client, cache: cache)
    }
}
