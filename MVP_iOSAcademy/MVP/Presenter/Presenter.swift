//
//  Presenter.swift
//  MVP_iOSAcademy
//
//  Created by Mac mini on 2021/10/21.
//

import UIKit

// https://jsonplaceholder.typicode.com/users

// all data handling process need to be done in controller if it were mvC
protocol UserPresenterDelegate: AnyObject {
    func presentUsers(users: [User])
//    func presentAlert(title: String, message: String)
}

// delegate of Presenter need to be UIViewController
typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(users: users)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // the delegate of Presenter is UIViewController
    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func didTap(user: User) {
        
        let title = user.name
        let message = "\(user.name) has an email of \(user.email) & a username of \(user.username)"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        delegate?.present(alert, animated: true)
        
    }
}
