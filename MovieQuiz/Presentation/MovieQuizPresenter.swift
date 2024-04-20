import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate{
    weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestionIndex: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    var statisticService: StatisticService!
    let questionsAmount: Int = 10
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    // MARK: - convertFunction
        func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        }
    // MARK: - QuestionFactoryDelegate
        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
        func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()// скрываем индикатор загрузки
            questionFactory?.requestNextQuestion()
        }
        func proceedToNextQuestionOrResults() {
            if self.isLastQuestion() {
                statisticService?.store(correct: correctAnswers, total: questionsAmount)
                viewController?.showResult()
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
                viewController?.buttonClickEnable()
            }
        }
        func makeResultMessage() -> String{
            
            guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
                assertionFailure("error message")
                return ""
            }
            let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
            let totalPlaysCountLine = "Количество сыграных квизов: \(statisticService.gamesCount)"
            let currentGameResultsLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + "(\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(accuracy))%"
            let resultMessage = [
                currentGameResultsLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            return resultMessage
        }
    // MARK: - Functions
    
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

        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.viewController?.border()
        }
    }
        func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
            viewController?.buttonClickEnable()
            viewController?.border()
        }
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    }

