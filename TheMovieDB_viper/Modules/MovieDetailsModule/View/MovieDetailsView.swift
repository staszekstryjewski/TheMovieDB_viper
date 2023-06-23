//
//  MovieDetailsView.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 21/06/2023.
//

import UIKit

final class MovieDetailsView: UIView {
    private enum Constants  {
        static let imageHeight: CGFloat = 300
        static let buttonSize: CGFloat = 32
        static let buttonPadding: CGFloat = 8
        static let stackSpacing: CGFloat = 12
        static let stackPadding: CGFloat = 8
    }

    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewTextView = UITextView().then {
        $0.isEditable = false
        $0.font = .systemFont(ofSize: 20)
        $0.isScrollEnabled = true
    }

    private lazy var favoritesButton = FavoritesButton().then {
        $0.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    private let stack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Constants.stackSpacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: Constants.stackPadding, bottom: 0, right: Constants.stackPadding)
    }

    private let spinner = UIActivityIndicatorView(style: .large)
    private let didTapButton: () -> Void

    init(didTapButton: @escaping () -> Void) {
        self.didTapButton = didTapButton
        super.init(frame: .zero)
        setup()
        setUpViewHierarchy()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSpinner(_ show: Bool) {
        favoritesButton.isHidden = show
        show ? spinner.startAnimating() : spinner.stopAnimating()
    }

    func fill(with model: MovieDetailsModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        ratingLabel.text = model.rating
        posterImageView.image = UIImage(systemName: "popcorn.circle")
        overviewTextView.text = model.overview
        posterImageView.image = model.image
        favoritesButton.isSelected = model.favorite
    }

    @objc private func buttonAction() {
        didTapButton()
    }

    private func setup() {
        backgroundColor = .white
        favoritesButton.layer.cornerRadius = Constants.buttonSize / 2
        favoritesButton.clipsToBounds = true
    }

    private func setUpViewHierarchy() {
        posterImageView.addSubview(spinner)
        addSubview(stack)
        stack.addArrangedSubview(posterImageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(ratingLabel)
        addSubview(overviewTextView)
        addSubview(favoritesButton)
    }

    private func setUpConstraints() {
        posterImageView.snp.makeConstraints {
            $0.height.equalTo(Constants.imageHeight)
        }

        stack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(overviewTextView.snp.top)
        }

        overviewTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaInsets.bottom)
            $0.top.equalTo(stack.snp.bottom)
        }

        favoritesButton.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom).inset(Constants.buttonPadding)
            $0.right.equalTo(posterImageView.snp.right).inset(Constants.buttonPadding)
            $0.height.width.equalTo(Constants.buttonSize)
        }

        spinner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
