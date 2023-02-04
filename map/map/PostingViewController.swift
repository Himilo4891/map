//
//  PostingViewController.swift
//  map
//
//  Created by abdiqani on 04/02/23.
//
import UIKit
import MapKit

class PostingViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide activity indicatory when stops
        self.activityIndicatorView.hidesWhenStopped = true
       
        //Set textfields to empty
        self.LocationText.text = ""
        self.mediaURLText.text = ""
        
        //Assign delegates for textFields
        self.LocationText.delegate = self
        self.mediaURLText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Subscribe to any keyboard notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //Unsubscribe from any keyboard notifications when view will disappear
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - dismiss: Dismiss the actual viewcontroller
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - findLocation: Reverse geolocate from string, if successful save date for passing to AddLocationsViewController
    @IBAction func findLocation(_ sender: Any) {
        setFindLocation(true)
        if self.LocationText.text != "" && self.mediaURLText.text != "" {
            self.mapString = LocationText.text
            self.mediaURL = mediaURLText.text
            getCoordinate(addressString: mapString, completionHandler: handleGeoLocation(location:error:))
        }else{
            showAlert(ofType: .emptyFields, message: "Some of the fields are still empty")
        }
    }
    //MARK: - prepare: Set the properties to pass to AddLocationViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue"{
            let controller = segue.destination as! AddLocationViewController
            controller.mapString = self.mapString
            controller.mediaURL = self.mediaURL
            controller.geoLocation = self.geoLocation
        }
    }
    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
    func showAlert(ofType type: AlertNotification.ofType, message: String) {
        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
        present(alertVC, animated: true)
        setFindLocation(false)
    }
    //MARK: - getCoordinate: Get the coordinates from string using geocodeAddressString
    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    if let location = placemark.location{
                        self.geoLocation = location.coordinate
                        completionHandler(location.coordinate, nil)
                    }
                }
            }else {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
        }
    }
    //MARK: - handleGeoLocation: If obtained location is valid perfom segue if not show alert
    func handleGeoLocation(location : CLLocationCoordinate2D, error : NSError?){
        if let _ = error{
            showAlert(ofType: .incorrectGeoLocation, message: "The location provided doesn't exist")
        }else{
            setFindLocation(false)
            performSegue(withIdentifier: "addLocationSegue", sender: nil)
        }
    }
    
    //MARK: - setFindLocation: Control the activityViewIndicatior when to start and stop animating
    func setFindLocation(_ findLocation: Bool){
        if findLocation {
           activityIndicatorView.startAnimating()
        } else {
           activityIndicatorView.stopAnimating()
        }
        findLocation.isEnabled = !findLocation
    }
    
    //MARK:- KeyBoard Subscriber Notification
   func subscribeToKeyboardNotifications() {
       
       //Subscribe to keyboardWillShow(_:) notifications
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
       //Subscribe to keyboardWillHide(_:) notifications
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }
   
   //MARK: -KeyBoard Unsubscriber Notification
   func unsubscribeFromKeyboardNotifications() {
       
       //Unsubscribe from keyboardWillShow(_:) notifications
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       //Unsubscribe from keyboardWillShow(_:) notifications
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
   }

   //MARK: - keyboardWillShow Function
   @objc func keyboardWillShow(_ notification:Notification) {
       /*Set view y value upper for keyboard to not hide the textfield and verify that
       it is only for the bottom textfield, if not both will push the view upper */
       if self.mediaURLText.isEditing {
           view.frame.origin.y -= getKeyboardHeight(notification)
       }
   }
   
   //MARK: - keyboardWillHide Function
   @objc func keyboardWillHide(_ notification:Notification) {
       //Set view y value back to origin when keyboard will be dismissed
       //Can also be set as view.frame.origin.y = 0
       if self.mediaURLText.isEditing {
           view.frame.origin.y += getKeyboardHeight(notification)
       }
   }

   //MARK: - getKeyboardHeight Function : Get Keyboard Height from notification
   func getKeyboardHeight(_ notification:Notification) -> CGFloat {
       //Get userInfo dictionary [AnyHashable : Any]?
       let userInfo = notification.userInfo
       // Get the keyboardSize attributes from dictionary
       let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
       //Return height of the keyboard
       return keyboardSize.cgRectValue.height
   }
    
}

extension PostingViewController: UITextFieldDelegate {
   
    //MARK: textFieldShouldReturn: Dismiss keyboard if return was pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
