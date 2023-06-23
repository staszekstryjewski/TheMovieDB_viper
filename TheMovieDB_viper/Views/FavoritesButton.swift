//
//  FavoritesButton.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import UIKit

final class FavoritesButton: UIButton {
    init() {
        super.init(frame: .zero)
        tintColor = .red
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            let normalImage = isSelected ? selectedImage : unselectedImage
            let highlighted = isSelected ? unselectedImage : selectedImage
            setImage(normalImage, for: .normal)
            setImage(highlighted, for: .highlighted)
        }
    }

    private let selectedImage = UIImage(systemName: "star.fill")
    private let unselectedImage = UIImage(systemName: "star")
}
