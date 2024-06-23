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
