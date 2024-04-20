import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    var questionFactory: QuestionFactoryProtocol?{get set}
    func yesButtonClicked()
    func noButtonClicked()
    func makeResultMessage()-> String
    func restartGame()
}
