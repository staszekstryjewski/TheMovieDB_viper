//
//  UIViewController+showAlert.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 23/06/2023.
//

import UIKit

protocol AlertShowing {
    func showAlert(_ message: String)
}

extension AlertShowing where Self: UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancel)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: false)
        }

    }
}
