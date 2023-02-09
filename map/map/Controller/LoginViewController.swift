
import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var SingUp: UIButton!
    @IBOutlet weak var activityViewIndicatior: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
       
        self.activityViewIndicatior.hidesWhenStopped = true
        
       
        self.Email.delegate = self
        self.Password.delegate = self
        
       
        self.Email.text = ""
        self.Password.text = ""
    }

    
    @IBAction func login(_ sender: Any) {
        setLogin(true)
        UdacityClient.login(Email: Email.text ?? "", Password: Password.text ?? "", completionHandler: handleLoginResponse(success:error:))
           }
   
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        setLogin(false)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                print("hello")
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                print("hello 5")
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLogin(true)
        if success {
            print("hello 2")
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            print("hello 6")
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print("hello 4")
            UdacityClient.login(Email: self.Email.text ?? "", Password: self.Password.text ?? "", completionHandler: self.handleLoginResponse(success:error:))
        }
    }
    func setLogin(_ isLogin: Bool){
        if isLogin{
            activityViewIndicatior.startAnimating()
        }else{
            activityViewIndicatior.stopAnimating()
        }
         Email.isEnabled = !isLogin
        Password.isEnabled = !isLogin
        Login.isEnabled = !isLogin
        SingUp.isEnabled = !isLogin
    }
    
       override func viewDidLoad() {
           let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign up.")
           attributedString.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 8))

       }
       
       func textView(_ textView: UILabel, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           UIApplication.shared.open(URL)
           return false
       }


}

