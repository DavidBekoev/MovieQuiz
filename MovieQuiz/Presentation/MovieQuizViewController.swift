import UIKit
final class MovieQuizViewController: UIViewController {
    
    
    
    
    // MARK: - Lifecycle
//    private var currentQuestion: QuizQuestion?
  //  var questionFactory: QuestionFactoryProtocol?
   // var correctAnswers = 0
    var presenter: MovieQuizPresenter!
    private var alertDelegate: AlertPresenterProtocol?
   // private var statisticService: StatisticServiceProtocol?
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak private var noButtom: UIButton!
    @IBOutlet weak private var yesButtom: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //    presenter = MovieQuizPresenter(viewController: self)
        //presenter.viewController = self
        showLoadingIndicator()
       // statisticService = StatisticService()
        imageView.layer.cornerRadius = 20
      // questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
      //  questionFactory?.loadData()
      //  questionFactory?.requestNextQuestion()
        
        
     //   let alertDelegate = AlertPresenter()
     //   alertDelegate.alertController = self
     //   self.alertDelegate = alertDelegate
    }
    
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//       presenter.didReceiveNextQuestion(question: question)
//    }
    
  //     func didLoadDataFromServer() {
   //     activityIndicator.isHidden = true // скрываем индикатор загрузки
//        questionFactory?.requestNextQuestion()
 //   }

 //      func didFailToLoadData(with error: Error) {
 //       showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
 //      }

  
    
        func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
     func hideLoadingIndicator() {
        activityIndicator.isHidden = true
     //   activityIndicator.stopAnimating()

       
    }
    
     func showNetworkError(message: String) {
       hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
         //   self.presenter.currentQuestionIndex = 0
         //  self.presenter.correctAnswers = 0
          // self.presenter.questionFactory?.loadData()
            self.presenter.restartGame()
        }
        alertDelegate?.show(alertModel: model)
    }
    
    
         func show(quiz step: QuizStepViewModel) {
             imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
         imageView.layer.masksToBounds = true
         imageView.layer.borderWidth = 8
         imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
     }
  /*
      func showAnswerResult(isCorrect: Bool) {
             presenter.didAnswer(isYes: isCorrect)
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
                 self.presenter.alertDelegate = self.alertDelegate
                 self.presenter.imageView = self.imageView
           //      self.presenter.statisticService = self.statisticService
                self.imageView.layer.borderWidth = 0
                 self.presenter.showNextQuestionOrResults()
                
            }
        }
        */
        
        private func activateButtons(){
            noButtom.isEnabled = true
            yesButtom.isEnabled = true
        }
        private func deactivateButtons (){
            noButtom.isEnabled = false
            yesButtom.isEnabled = false
        }
        /*
     func showNextQuestionOrResults() {
        if presenter.currentQuestionIndex == presenter.questionsAmount - 1 {
            presenter.statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            let bestGame = statisticService?.bestGame
            imageView.layer.borderColor = CGColor(gray: 0.0, alpha: 0)
            let text = """
    Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
    Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
    Рекорд: \(bestGame?.correct ?? 0)/\(presenter.questionsAmount) (\(String(describing: bestGame?.date.dateTimeString ?? "")))
    Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? ""))%
    """
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз",
                completion: {
                    self.presenter.currentQuestionIndex = 0
                    self.presenter.correctAnswers = 0
                 //   self.questionFactory?.requestNextQuestion()
                })
            alertDelegate?.show(alertModel: alertModel)
            presenter.correctAnswers = 0
        } else {
            presenter.currentQuestionIndex += 1
    //        questionFactory?.requestNextQuestion()
        }
    }
       */
            
     func show(quiz result: QuizResultsViewModel) {
     let alert = UIAlertController(
         title: result.title,
         message: result.text,
         preferredStyle: .alert)
   //      let message = presenter.makeResultsMessage()
     let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
         guard let self = self else { return }
      //   self.presenter.currentQuestionIndex = 0
      //   self.presenter.correctAnswers = 0
         self.presenter.restartGame()
      //   self.presenter.questionFactory?.requestNextQuestion()
     }
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
         guard let self = self else { return }
         self.presenter.proceedToNextQuestionOrResults()
         
     }
     
     alert.addAction(action)
     
     self.present(alert, animated: true, completion: nil)
    }
     

        
       
    
        
        @IBAction private func noButtonClicked(_ sender: Any) {
          //  deactivateButtons()
       //     presenter.currentQuestion = currentQuestion
            presenter.noButtonClicked()
        }
        
        @IBAction private func yesButtonClicked(_ sender: Any) {
         //   deactivateButtons()
       //     presenter.currentQuestion = currentQuestion
            presenter.yesButtonClicked()
        }
    }
    
    

