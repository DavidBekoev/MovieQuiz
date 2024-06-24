//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Давид Бекоев on 23.06.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
   private var correctAnswers = 0
   private var questionFactory: QuestionFactoryProtocol?
   private let statisticService: StatisticServiceProtocol!
   private var alertDelegate: AlertPresenterProtocol?
   private var imageView: UIImageView!
   private let questionsAmount: Int = 10
   private var currentQuestionIndex = 0
   private  var currentQuestion: QuizQuestion?
   private weak var viewController: MovieQuizViewController?
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
  
    
    // MARK: - QuestionFactoryDelegate
    
        func didLoadDataFromServer() {
               viewController?.hideLoadingIndicator()
               questionFactory?.requestNextQuestion()
           }
        func didFailToLoadData(with error: Error) {
               let message = error.localizedDescription
               viewController?.showNetworkError(message: message)
           }
    
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
        
        func restartGame() {
               currentQuestionIndex = 0
               correctAnswers = 0
               questionFactory?.requestNextQuestion()
           }
           
    
    func proceedToNextQuestionOrResults() {
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
    
    
    func didAnswer(isCorrectAnswer: Bool) {
           if isCorrectAnswer {
               correctAnswers += 1
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
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
              }
            
              let givenAnswer = isYes
            
               viewController?.presenter.proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    func makeResultsMessage() -> String {
           statisticService.store(correct: correctAnswers, total: questionsAmount)
           
           let bestGame = statisticService.bestGame
           
           let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
           let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
           let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
           + " (\(bestGame.date.dateTimeString))"
           let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
           
           let resultMessage = [
               currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
           ].joined(separator: "\n")
           
           return resultMessage
       }
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
       //   if isCorrect {
       //       correctAnswers += 1
       //   }
          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = 8
          imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)  {
              //guard let self = self else { return }
             // self.showNextQuestionOrResults()
            // self.presenter.correctAnswers = self.presenter.correctAnswers
              //           self.presenter.questionFactory = self.questionFactory
                      
              // self.presenter.correctAnswers = self.correctAnswers
           //    self.presenter.questionFactory = self.questionFactory
               self.alertDelegate = self.alertDelegate
               self.imageView = self.imageView
         //      self.presenter.statisticService = self.statisticService
              self.imageView.layer.borderWidth = 0
               self.proceedToNextQuestionOrResults()
              
          }
      }
    
   
}
