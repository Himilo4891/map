////
////  Login.swift
////  map
////
////  Created by abdiqani on 01/02/23.
////
//
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
        //Hide activity indicatory when stops
        self.activityViewIndicatior.hidesWhenStopped = true
        
        //Assign delegates for textFields
        self.Email.delegate = self
        self.Password.delegate = self
        
        //Set textfields to empty
        self.Email.text = ""
        self.Password.text = ""
    }

    //MARK: - login: Login if the user pressed the button
    @IBAction func login(_ sender: Any) {
        setLogin(true)
        UdacityClient.login(Email: Email.text ?? "", Password: Password.text ?? "", completionHandler: handleLoginResponse(success:error:))
           }
    //MARK: - signUp: Open Sign Up Page from Udacity
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
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
    //MARK: - setLogin: Control the activityViewIndicatior when to start and stop animating
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

//           webLink.attributedText = attributedString
       }
       
       func textView(_ textView: UILabel, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           UIApplication.shared.open(URL)
           return false
       }


}

