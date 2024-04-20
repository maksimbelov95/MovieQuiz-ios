import Foundation
import UIKit

protocol AlertPresenterProtocol{
    func showAllert(alertModel: AlertModel)
}

final class AlertPresenter {
    
    func show(view controller: UIViewController, alertModel: AlertModel) {
        let alertController = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .default,
                                   handler: { _ in
            alertModel.completion()
        })
        
        alertController.view.accessibilityIdentifier = "Game results"
        
        alertController.addAction(action)
        
        controller.present(alertController, animated: true)
    }
}
