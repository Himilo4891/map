

import UIKit

class ViewController: UIViewController {
    
    @IBAction func login(_ sender: Any) {
           UdacityAPI.getRequestToken(completion: handleRequestTokenResponse(success: error:))
           }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "login", sender: nil)
           
        }
    
    
}
}

