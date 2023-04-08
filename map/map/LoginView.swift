//
//  ViewController.swift
//  map
//
//  Created by abdiqani on 01/02/23.
//

import UIKit

class LoginView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "login", sender: nil)
            //print(UdacityAPI.Auth.sessionId)
            
        }
    
    
}
}

