import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Properties
    private var presenter: QuestionFactoryDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter = MovieQuizPresenter(viewController: self)
    }
    // MARK: - IBActions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
        buttonClickDisable()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
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
 
    func setup(){
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionText.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func showResult(){
        guard let message = presenter?.makeResultMessage() else {return}
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message,
                                    buttonText: "Сыграть еще раз?") { [weak self] in
            guard let self = self else { return }
            self.presenter?.restartGame()
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
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)) { [weak self] in
                    self?.presenter?.restartGame()
                    self?.presenter?.questionFactory?.loadData()
                    self?.presenter?.questionFactory?.requestNextQuestion()
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
