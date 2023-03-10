
import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SingUp: UIButton!
    @IBOutlet weak var activityViewIndicatior: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        Email.text = ""
        Email.textColor = .black
        Email.delegate = self
        Password.text = ""
        Password.textColor = .black
        Password.delegate = self
        
        //set placeholder text for textfields
        Email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        Password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        //before view appears
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        activityViewIndicatior.isHidden = true
        Password.isSecureTextEntry = true
        Email.textColor = .black
        Password.textColor = .black
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        //when view disappears
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
        unsubscribeFromKeyboardNotifications()
        
    }
    @objc func keyboardWillShow(_ notification:Notification) {
            if Password.isEditing || Email.isEditing {
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
    @IBAction func login(_ sender: Any) {
        setLoggingIn(true)
//        fieldsChecker()
        if (Email.text?.isEmpty)! || (Password.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Required Fields", message: "The credentials were incorrect, please check your email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }else {
            setLoggingIn(true)
            UdacityClient.login(Email: Email.text ?? "", Password: Password.text ?? "", completionHandler: handleLoginResponse(success:error:))
        }
    }
    func setLoggingIn (_ loggingIn: Bool) {
        if loggingIn {
            activityViewIndicatior.startAnimating()
        } else {
            activityViewIndicatior.stopAnimating()
        }
    }
   
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    private func fieldsChecker(){
        if (Email.text?.isEmpty)! || (Password.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Credentials were not filled in", message: "Please fill both email and password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.setLoggingIn(true)
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func handleLoginResponse(success:Bool, error: Error?) {
        if success { performSegue(withIdentifier: "completeLogin", sender: nil)
            setLoggingIn(true)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "Wrong Email or Password!!")
            setLoggingIn(false)
        }
    }
    }
    
    
    

       
       
       func textView(_ textView: UILabel, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           UIApplication.shared.open(URL)
           return false
       }




