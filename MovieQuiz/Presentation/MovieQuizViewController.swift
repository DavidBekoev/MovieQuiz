import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    
    // MARK: - Lifecycle
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var alertDelegate: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noButtom: UIButton!
    @IBOutlet weak var yesButtom: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        statisticService = StatisticService()
        imageView.layer.cornerRadius = 20
           questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
           statisticService = StatisticService()

           showLoadingIndicator()
        questionFactory?.loadData()
        
        
      //  let questionFactory = QuestionFactory()
      //  questionFactory.setup(delegate: self)
      //  self.questionFactory = questionFactory
        questionFactory?.requestNextQuestion()
        
        let alertDelegate = AlertPresenter()
        alertDelegate.alertController = self
        self.alertDelegate = alertDelegate
    }
    
    
    
    
    // MARK: - QuestionFactoryDelegate
        func didReceiveNextQuestion(question: QuizQuestion?) {
                 guard let question = question else {
                   return
               }
             currentQuestion = question
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()

    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
       }

    
    
       private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    private func hideLoadingIndicator() {
       
    }
    
    private func showNetworkError(message: String) {
       hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.loadData()
        }
        
        alertDelegate?.show(alertModel: model)
    }
    
    
   
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
        
        private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
            
        private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
            
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.activateButtons()
                self.imageView.layer.borderWidth = 0
                self.showNextQuestionOrResults()
            }
        }
        
        
        private func activateButtons(){
            noButtom.isEnabled = true
            yesButtom.isEnabled = true
        }
        private func deactivateButtons (){
            noButtom.isEnabled = false
            yesButtom.isEnabled = false
        }
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
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
       
            
        
        
      private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
        
    
        
        @IBAction private func noButtonClicked(_ sender: Any) {
            deactivateButtons()
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            
        }
        
        @IBAction private func yesButtonClicked(_ sender: Any) {
            deactivateButtons()
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        
    }
    
    

