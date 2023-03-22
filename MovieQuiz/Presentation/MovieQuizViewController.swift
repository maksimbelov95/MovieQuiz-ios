import UIKit

final class MovieQuizViewController: UIViewController {
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
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
        super.viewDidLoad()
        counterLabel.font = UIFont(name: "YS Display-Medium", size: 20)
        textLabel.font = UIFont(name: "YS Display-Bold", size: 23)
        questionText.font = UIFont(name: "YS Display-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        let currentQuestion = questions[currentQuestionIndex] //берем данные из массива
        let currentquiz = convert(model: currentQuestion)  // конвертируем их
        show(quiz: currentquiz)                            //выводим на экран
   
    }
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var bestScore: Int = 0
    private var date = NSDate()
    private var totalPlayed = 0
    private var accuracySumm:Double = 0
    
    
    // для состояния "Вопрос задан"
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }

    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    

    private func show(quiz result: QuizResultsViewModel) {
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
      }
    private func show(quiz step: QuizStepViewModel) {
       
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
        if currentQuestionIndex == questions.count - 1 {
            totalPlayed += 1
            accuracySumm = accuracySumm + Double(correctAnswers)
            print(accuracySumm)
            print(totalPlayed)
            var accuracy: Double {return (accuracySumm)/(10*Double(totalPlayed))*100}
            print(accuracy)
          if bestScore < correctAnswers{
              bestScore = correctAnswers
              date = NSDate()
          }
          let resultMessage = """
          Ваш результат: \(correctAnswers) из 10
          Луший результат за сессию: \(bestScore)
          Дата лучшей сессии: \(date)
          Всего сыграно: \(totalPlayed)
          Точность правильных ответов: \(Int(accuracy))%
          """
          let alert = UIAlertController(title: "Этот раунд окончен!", // заголовок всплывающего окна
                                        message: resultMessage,// текст во всплывающем окне
                                        preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

          // создаём для него кнопки с действиями
          let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { [self] _ in
              correctAnswers = 0
              currentQuestionIndex = 0
              let currentQuestion = questions[currentQuestionIndex]
              let currentquiz = convert(model: currentQuestion)
              self.show(quiz: currentquiz)
              yesButton.isEnabled = true
              noButton.isEnabled = true
          }

          // добавляем в алерт кнопки
          alert.addAction(action)

          // показываем всплывающее окно
         
          self.present(alert, animated: true, completion: nil)
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего квиза на 1
          let currentQuestion = questions[currentQuestionIndex]
          let currentquiz = convert(model: currentQuestion)
          show(quiz: currentquiz)      // показать следующий вопрос
          yesButton.isEnabled = true
          noButton.isEnabled = true
      }
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
 Ответ: НЕТ


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

