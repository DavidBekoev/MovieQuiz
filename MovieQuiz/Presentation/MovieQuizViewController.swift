import UIKit
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    var presenter: MovieQuizPresenter!
    private var alertDelegate: AlertPresenterProtocol?
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak private var noButtom: UIButton!
    @IBOutlet weak private var yesButtom: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
  //      alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        imageView.layer.cornerRadius = 20
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        
        
        
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
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
    
     func activateButtons(){
        noButtom.isEnabled = true
        yesButtom.isEnabled = true
    }
     func deactivateButtons (){
        noButtom.isEnabled = false
        yesButtom.isEnabled = false
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
           let message = presenter.makeResultsMessage()

           let alert = UIAlertController(
               title: result.title,
               message: message,
               preferredStyle: .alert)

               let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                   guard let self = self else { return }

                   self.presenter.restartGame()
               }

           alert.addAction(action)

           self.present(alert, animated: true, completion: nil)
       }
    
        
        @IBAction private func noButtonClicked(_ sender: Any) {
              deactivateButtons()
            //     presenter.currentQuestion = currentQuestion
            presenter.noButtonClicked()
        }
        
        @IBAction private func yesButtonClicked(_ sender: Any) {
               deactivateButtons()
            //     presenter.currentQuestion = currentQuestion
            presenter.yesButtonClicked()
        }
    }
    
    
    

