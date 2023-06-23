//
//  MovieDetailsViewController.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit
import SnapKit

final class MovieDetailsViewController: UIViewController, AlertShowing {
    var presenter: DetailsPresenter?

    private lazy var mainView = MovieDetailsView { [weak self] in
        self?.presenter?.didTapStar()
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.showSpinner(true)
        presenter?.viewDidLoad()
        title = "Movie details"
    }

}

extension MovieDetailsViewController: DetailsView {
    func present(_ item: MovieDetailsModel) {
        mainView.fill(with: item)
        mainView.showSpinner(false)
    }

    func showError(_ message: String) {
        mainView.showSpinner(false)
        showAlert(message)
    }
}
