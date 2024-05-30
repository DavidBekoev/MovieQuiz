//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 29.05.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
} 
