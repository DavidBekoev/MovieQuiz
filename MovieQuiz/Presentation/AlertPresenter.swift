//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 30.05.2024.
//

    import UIKit

final class AlertPresenter:  AlertPresenterProtocol {
    
    weak var alertController: UIViewController?
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
                   title: alertModel.title,
                   message: alertModel.message,
                   preferredStyle: .alert
               )
        alert.view.accessibilityIdentifier = "Game Result"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
                   alertModel.completion()
               }
        alert.addAction(action)
        alertController?.present(alert, animated: true)
    }
}
