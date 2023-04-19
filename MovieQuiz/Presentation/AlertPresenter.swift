import Foundation
import UIKit

protocol AlertPresenterProtocol{
    func showAllert(alertmodel: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol{
    
   private weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController? = nil) {
        self.viewController = viewController
    }
    
    func showAllert(alertmodel: AlertModel) {
        let alert = UIAlertController(title: alertmodel.title, // заголовок всплывающего окна
                                      message: alertmodel.message,// текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        let action = UIAlertAction(title: alertmodel.ButtonText, style: .default) { _ in
            alertmodel.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
