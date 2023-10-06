//
//  LoginViewController.swift
//  LoginFramework
//
//  Created by VT on 10/5/23.
//

import UIKit

public class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfAccountID: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    public convenience init() {
        self.init(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        observeKeyboard()
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tfDidEndOnExit_Pressed(_ sender: UITextField) {
    }
    
    @IBAction func btnForgotPassword_Pressed(_ sender: UIButton) {
        self.showAlert(message: "You are going to perform Forgot password ?", viewController: self)
    }
    
    @IBAction func btnSignIn_Pressed(_ sender: UIButton) {
        guard let accountID = self.tfAccountID.text, !accountID.isEmpty else {
            self.showAlert(message: "Account ID cannot be empty", viewController: self)
            return
        }
        guard let password = self.tfPassword.text, !password.isEmpty else {
            self.showAlert(message: "Password cannot be empty", viewController: self)
            return
        }
        
        self.showAlert(message: "You are going to login with accountID = \(accountID) and password = \(password)", viewController: self)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func showAlert(message: String?, viewController: UIViewController) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfAccountID {
            self.tfPassword.becomeFirstResponder()
        } else {
            self.tfPassword.resignFirstResponder()
        }
        return true
    }
}

extension UITextField {
    func setColorPlaceholder(color: UIColor) {
        let placeholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
        self.attributedPlaceholder = placeholder
    }
    
    func setColorClearButton(color: UIColor) {
        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = color
        }
    }
}
