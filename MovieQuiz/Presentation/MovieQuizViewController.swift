import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionText.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        presenter = MovieQuizPresenter(viewController: self)
    }
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        buttonClickDisable()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        buttonClickDisable()
    }
    //MARK: - IBOutlets
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet private var questionText: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
 
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func showResult() {
        let message = presenter.makeResultMessage()
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message,
                                    buttonText: "Сыграть еще раз?") { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        let alert = AlertPresenter()
        alert.show(view: self, alertModel: alertModel)
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: "Попробовать ещё раз",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.showLoadingIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)) {
                    self.presenter.restartGame()
                    self.presenter.questionFactory?.loadData()
                    self.presenter.questionFactory?.requestNextQuestion()
                }
            }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
    }
    func buttonClickDisable(){
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    func buttonClickEnable(){
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    func border(){
        imageView.layer.borderWidth = 0
    }
}
 
        
        






/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ€


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

