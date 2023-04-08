
import UIKit
import MapKit

class PostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var mediaURLText: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    //IBOutlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    //Properties
    var mapString: String!
    var mediaURL: String!
    var geoLocation: CLLocationCoordinate2D!
    private var presentingController: UIViewController?
    var geocoder = CLGeocoder()
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var keyboardIsVisible = false
    var mediaUrl: String = ""
    var pinnedLocation: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        ActivityIndicator.isHidden = true
        LocationText.delegate = self
        mediaURLText.delegate = self
        hideKeyboardWhenTappedAround()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideKeyboardWhenTappedAround()
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func findLocation (_ sender: Any) {
        
        
        guard let location = LocationText.text else {return}
        findGeocode("\(location)")
        
        
    }
    
   
    
    func findGeocode(_ address: String) {
        self.activityIndicator(true)
        CLGeocoder().geocodeAddressString(address) { (placemark, error)
            in
            if error == nil {
                
                if let placemark = placemark?.first,
                   let location = placemark.location {
                    self.latitude = Float(location.coordinate.latitude)
                    self.longitude = Float(location.coordinate.longitude)
                    
                    print("Latitude:\(self.latitude), Longitude:\(self.longitude)")
                
                    self.performSegue(withIdentifier: "toLocationVC", sender: nil)
                }
                
            }else {
                let alert = UIAlertController(title: "Error", message: "Geocode could not find. Try again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                print("geocode error")
            }
            self.activityIndicator(false)
}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationVC" {
            if let mapVC = segue.destination as? AddLocationViewController {
                mapVC.location = mediaURLText.text ?? ""
                mapVC.location = LocationText.text ?? ""
                mapVC.latitude = Double(latitude)
                mapVC.longitude = Double(longitude)
            }
        }
    }
    func hideKeyboardWhenTappedAround() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == LocationText{
        textField.resignFirstResponder()
            mediaURLText.becomeFirstResponder()
        }
        return true
    }
        
        func activityIndicator(_ running : Bool){
            
            if running {
                DispatchQueue.main.async {
                    self.ActivityIndicator.startAnimating()
                }
            }else {
                DispatchQueue.main.async {
                    self.ActivityIndicator.stopAnimating()
                }
            }
            
            LocationText.isEnabled = !running
            mediaURLText.isEnabled = !running
            findLocation.isEnabled = !running
            
            ActivityIndicator.isHidden = !running
        
        
    }
    

        
        
        func showFailure(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    @objc func keyboardWillShow(_ notification:Notification) {
            if !keyboardIsVisible {
                if LocationText.isEditing {
                    view.frame.origin.y -= getKeyboardHeight(notification) - 50 - mediaURLText.frame.height - findLocation.frame.height
                } else if mediaURLText.isEditing {
                    view.frame.origin.y -= getKeyboardHeight(notification) - 50 - findLocation.frame.height
                }
                keyboardIsVisible = true
            }
        }
    @objc func keyboardWillHide(_ notification:Notification) {
            if keyboardIsVisible {
                view.frame.origin.y = 0
                keyboardIsVisible = false
            }
        }
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        }
//
        func unsubscribeFromKeyboardNotifications() {
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            
        }
        
    
        
    }

