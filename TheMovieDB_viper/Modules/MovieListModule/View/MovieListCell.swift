//
//  MovieListCell.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 22/06/2023.
//

import UIKit
import SnapKit

final class MovieListCell: UITableViewCell {
    private enum Constants  {
        static let buttonSize: CGFloat = 32
        static let labelPadding: CGFloat = 8
    }

    static let reuseIndentifier = "MovieListCellId"
    private let selectedImage = UIImage(systemName: "star.fill")
    private let unselectedImage = UIImage(systemName: "star")

    var didTapButton: (() -> Void)?

    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var favoritesButton = FavoritesButton().then {
        $0.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    func fill(with model: MovieListModel) {
        favoritesButton.isSelected = model.favorite
        titleLabel.text = model.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @objc private func buttonAction() {
        didTapButton?()
    }
    
    private func setup() {
        selectionStyle = .none
    }

    private func setupViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoritesButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(Constants.labelPadding)
        }

        favoritesButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.labelPadding)
            $0.centerY.equalTo(snp.centerY)
            $0.height.width.equalTo(Constants.buttonSize)
        }
    }

}
