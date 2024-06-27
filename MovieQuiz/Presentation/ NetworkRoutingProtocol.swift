//
//   NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 27.06.2024.
//

import Foundation
protocol networkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
