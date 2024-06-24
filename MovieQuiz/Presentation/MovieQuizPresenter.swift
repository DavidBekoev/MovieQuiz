//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 23.06.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestionIndex = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
     var statisticService: StatisticServiceProtocol?
    var alertDelegate: AlertPresenterProtocol?
     var imageView: UIImageView!
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            // self?.activateButtons()
        }
    }
    
    func showNextQuestionOrResults() {
        if self.currentQuestionIndex == questionsAmount - 1 {
           statisticService?.store(correct: correctAnswers, total: questionsAmount)
           let bestGame = statisticService?.bestGame
           imageView.layer.borderColor = CGColor(gray: 0.0, alpha: 0)
           let text = """
   Ваш результат: \(correctAnswers)/\(questionsAmount)
   Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
   Рекорд: \(bestGame?.correct ?? 0)/\(questionsAmount) (\(String(describing: bestGame?.date.dateTimeString ?? "")))
   Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? ""))%
   """
           let alertModel = AlertModel(
               title: "Этот раунд окончен!",
               message: text,
               buttonText: "Сыграть еще раз",
               completion: {
                   self.currentQuestionIndex = 0
                   self.correctAnswers = 0
                   self.questionFactory?.requestNextQuestion()
               })
           alertDelegate?.show(alertModel: alertModel)
           correctAnswers = 0
       } else {
           currentQuestionIndex += 1
           questionFactory?.requestNextQuestion()
       }
   }
    
    
    
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
