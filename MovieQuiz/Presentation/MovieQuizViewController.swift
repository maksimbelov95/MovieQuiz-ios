import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var questionText: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()//YSDisplay-Bold

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticServise = StatisticServiceImplementation()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        documentsURL.appendPathComponent(fileName)
        let jsonString = try? String(contentsOf: documentsURL)
    }
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = nil
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var bestScore: Int = 0
    private var date = NSDate()
    private var totalPlayed = 0
    private var accuracySumm:Double = 0
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticServise: StatisticService?
    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = "inception.json"
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
        func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }
    
    private func showAnswerResult(isCorrect: Bool) {
            yesButton.isEnabled = false
            noButton.isEnabled = false
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            imageView.layer.borderWidth = 8
            if isCorrect{
                correctAnswers += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
                self.imageView.layer.borderWidth = 0
                self.showNextQuestionOrResults()
            }
        }
        
    private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                showFinalResults()
            } else {
                currentQuestionIndex += 1 // увеличиваем индекс текущего квиза на 1
                questionFactory?.requestNextQuestion()
                }     // показать следующий вопрос
                yesButton.isEnabled = true
                noButton.isEnabled = true
            }
    
    private func showFinalResults() {
        statisticServise?.store(correct: correctAnswers, total: questionsAmount)
 
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: makeResultMessage(),
            ButtonText: "Сыграть еще раз?",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showAllert(alertmodel: alertModel)
    }
    private func makeResultMessage() -> String{
        
        guard let statisticServise = statisticServise, let bestGame = statisticServise.bestGame else {
            assertionFailure("error message")
            return ""
        }
        let accuracy = String(format: "%.2f", statisticServise.totalAccuracy)
        let totalPlaysCountLine = "Количество сыграных квизов: \(statisticServise.gamesCount)"
        let currentGameResultsLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(accuracy))%"
        let resultMessage = [
        currentGameResultsLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        return resultMessage
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

