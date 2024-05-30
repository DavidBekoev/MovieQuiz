//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 30.05.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    var alertController: UIViewController? { get set }
    func show(alertModel: AlertModel)
}
