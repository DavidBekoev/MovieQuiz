//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 25.06.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
