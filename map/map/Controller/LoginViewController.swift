
import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SingUp: UIButton!
    @IBOutlet weak var activityViewIndicatior: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        email.textColor = .black
        email.delegate = self
        Password.textColor = .black
        Password.delegate = self
        hideKeyboardWhenTappedAround()
        activityViewIndicatior.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        navigationController?.tabBarController?.tabBar.isHidden = true
              
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
    }
   
    @IBAction func login(_ sender: Any) {
        if (email.text?.isEmpty)! || (Password.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Required Fields", message: "The credentials were incorrect, please check your email or password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }else {
            setLoggingIn(true)
            UdacityClient.login(Email: email.text ?? "", Password: Password.text ?? "", completionHandler: handleLoginResponse(success:error:))
        }
    }
    func setLoggingIn (_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityViewIndicatior.startAnimating()
            }
        }else {
            DispatchQueue.main.async {
                self.activityViewIndicatior.stopAnimating()
            }
        }
        email.isEnabled = !loggingIn
        Password.isEnabled = !loggingIn
        Login.isEnabled = !loggingIn
        SingUp.isEnabled = !loggingIn
        activityViewIndicatior.isHidden = !loggingIn
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email{
            textField.resignFirstResponder()
            Password.becomeFirstResponder()
        }
        return true
    }
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func handleLoginResponse(success:Bool, error: Error?) {
        if success {
            print(UdacityClient.Auth.objectId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            
        }
        else{
           
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if Password.isEditing || email.isEditing {
            view.frame.origin.y = (-1)*getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

       
    }

}



