
import UIKit
import MapKit

class PostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var mediaURLText: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    //IBOutlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
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
        LocationText.delegate = self
        mediaURLText.delegate = self
        self.LocationText.text = ""
        self.mediaURLText.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocation (_ sender: Any) {
        
        if LocationText.text!.isEmpty {
            let alert = UIAlertController(title: "No Location", message: "No Location was entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            handleActivityIndicator(true)
            geocoder.geocodeAddressString(LocationText.text ?? "") { placemarks, error in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
        
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if error != nil {
            handleActivityIndicator(false)
            showFailure(title: "Location Do Not Exist", message: "The informed location doesn't exist.")
        } else {
            if let placemarks = placemarks, placemarks.count > 0 {
                let location = (placemarks.first?.location)! as CLLocation
                let coordinate = location.coordinate
                self.latitude = Float(coordinate.latitude)
                self.longitude = Float(coordinate.longitude)
                handleActivityIndicator(false)
                
//                let submitVC = storyboard?.instantiateViewController(identifier: "LocationFinalizedVC") as! LocationFinalizedVC
//                submitVC.locationRetrieved = LocationText.text
//                submitVC.urlRetrieved = mediaURLText.text
//                submitVC.latitude = self.latitude
//                submitVC.longitude = self.longitude
//
//                self.present(submitVC, animated: true, completion: nil)
                
                
            } else {
                handleActivityIndicator(false)
                showFailure(title: "Location Not Well Specified", message: "Try to use the full location name (Ex: California, USA).")
            }
        }
    }
    
    
    
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func handleActivityIndicator(_ findlocation: Bool) {
        if (findLocation != nil) {
                   activityIndicatorView.startAnimating()
                } else {
                   activityIndicatorView.stopAnimating()
                }
        findLocation.isEnabled = (findLocation == nil)
            }

    
    
    
    
    
    // MARK: Keyboard Functions
    
    
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
    
    // Function called when screen must be moved down
    @objc func keyboardWillHide(_ notification:Notification) {
        if keyboardIsVisible {
            view.frame.origin.y = 0
            keyboardIsVisible = false
        }
    }
    
    // Get keyboard size for move the screen
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Hide activity indicatory when stops
//        self.activityIndicatorView.hidesWhenStopped = true
//
//        //Set textfields to empty
//        self.LocationText.text = ""
//        self.mediaURLText.text = ""
//
//        //Assign delegates for textFields
//        self.LocationText.delegate = self
//        self.mediaURLText.delegate = self
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        //Subscribe to any keyboard notification
//        subscribeToKeyboardNotifications()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        //Unsubscribe from any keyboard notifications when view will disappear
//        unsubscribeFromKeyboardNotifications()
//    }
//
//    //MARK: - dismiss: Dismiss the actual viewcontroller
//    @IBAction func dismiss(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    //MARK: - findLocation: Reverse geolocate from string, if successful save date for passing to AddLocationsViewController
//    @IBAction func findLocation(_ sender: Any) {
//        setFindLocation(true)
//        if self.LocationText.text != "" && self.mediaURLText.text != "" {
//            self.mapString = LocationText.text
//            self.mediaURL = mediaURLText.text
//            getCoordinate(addressString: mapString, completionHandler: handleGeoLocation(location:error:))
//        }else{
//            showAlert(ofType: .emptyFields, message: "Some of the fields are still empty")
//        }
//    }
//    //MARK: - prepare: Set the properties to pass to AddLocationViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addLocationSegue"{
//            let controller = segue.destination as! AddLocationViewController
//            controller.mapString = self.mapString
//            controller.mediaURL = self.mediaURL
//            controller.geoLocation = self.geoLocation
//        }
//    }
//    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
//    func showAlert(ofType type: AlertNotification.ofType, message: String) {
//        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
//        present(alertVC, animated: true)
//        setFindLocation(false)
//    }
//    //MARK: - getCoordinate: Get the coordinates from string using geocodeAddressString
//    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
//
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
//            if error == nil {
//                if let placemark = placemarks?[0] {
//                    if let location = placemark.location{
//                        self.geoLocation = location.coordinate
//                        completionHandler(location.coordinate, nil)
//                    }
//                }
//            }else {
//                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
//            }
//        }
//    }
//    //MARK: - handleGeoLocation: If obtained location is valid perfom segue if not show alert
//    func handleGeoLocation(location : CLLocationCoordinate2D, error : NSError?){
//        if let _ = error{
//            showAlert(ofType: .incorrectGeoLocation, message: "The location provided doesn't exist")
//        }else{
//            setFindLocation(false)
//            performSegue(withIdentifier: "addLocationSegue", sender: nil)
//        }
//    }
//
//    //MARK: - setFindLocation: Control the activityViewIndicatior when to start and stop animating
//    func setFindLocation(_ findLocation: Bool){
//        if findLocation {
//           activityIndicatorView.startAnimating()
//        } else {
//           activityIndicatorView.stopAnimating()
//        }
////        findLocation.isEnabled = !findLocation
//    }
//
//    //MARK:- KeyBoard Subscriber Notification
//   func subscribeToKeyboardNotifications() {
//
//       //Subscribe to keyboardWillShow(_:) notifications
//       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//       //Subscribe to keyboardWillHide(_:) notifications
//       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//   }
//
//   //MARK: -KeyBoard Unsubscriber Notification
//   func unsubscribeFromKeyboardNotifications() {
//
//       //Unsubscribe from keyboardWillShow(_:) notifications
//       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//       //Unsubscribe from keyboardWillShow(_:) notifications
//       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//   }
//
//   //MARK: - keyboardWillShow Function
//   @objc func keyboardWillShow(_ notification:Notification) {
//       /*Set view y value upper for keyboard to not hide the textfield and verify that
//       it is only for the bottom textfield, if not both will push the view upper */
//       if self.mediaURLText.isEditing {
//           view.frame.origin.y -= getKeyboardHeight(notification)
//       }
//   }
//
//   //MARK: - keyboardWillHide Function
//   @objc func keyboardWillHide(_ notification:Notification) {
//       //Set view y value back to origin when keyboard will be dismissed
//       //Can also be set as view.frame.origin.y = 0
//       if self.mediaURLText.isEditing {
//           view.frame.origin.y += getKeyboardHeight(notification)
//       }
//   }
//
//   //MARK: - getKeyboardHeight Function : Get Keyboard Height from notification
//   func getKeyboardHeight(_ notification:Notification) -> CGFloat {
//       //Get userInfo dictionary [AnyHashable : Any]?
//       let userInfo = notification.userInfo
//       // Get the keyboardSize attributes from dictionary
//       let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//       //Return height of the keyboard
//       return keyboardSize.cgRectValue.height
//   }
//
//}
//
//extension PostingViewController: UITextFieldDelegate {
//
//    //MARK: textFieldShouldReturn: Dismiss keyboard if return was pressed
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
