//
//  MovieQuizViewControllerDelelegate.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 30.05.2024.
//

import Foundation
protocol MovieQuizViewControllerDelelegate: AnyObject {
    func showResult(alertModel: AlertModel)
}
