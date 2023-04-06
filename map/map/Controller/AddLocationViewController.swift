
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    //Properties
    var mapString: String!
    var mediaURL: String!
    var geoLocation: CLLocationCoordinate2D!
    
    private var presentingController : UIViewController?
    
    
    var url : String = ""
    var location : String = ""
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    //    var postLocationData: PostLocation?
    
    
    var locationRetrieved: String!
    var urlRetrieved: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        createMapAnnotation()
        tabBarController?.tabBar.isHidden = true
        activityIndicatorView.isHidden = true
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        //Generate the point in the map when the view appear
//        presentingController = presentingViewController
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = true
//
//
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            if let toOpen = view.annotation?.subtitle! {
//                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
//            }
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseId = "pin"
//
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
//
//        if pinView == nil {
//            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.tintColor = .red
//        } else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }
//
//
//    @IBAction func finishButtonPressed(_ sender: Any) {
//        setActivityIndicator(true)
//        UdacityClient.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
//    }
//
//
//
//        //        func handleUpdateLocation(success: Bool, error: Error?){
//        //            if success{
//        //                UdacityClient.user.location = location
//        //                UdacityClient.UserInfo.url = url
//        //                print("Student Location Updated")
//        //                navigationController?.popToRootViewController(animated: true)
//        //            }else{
//        //                print("Student Location cannot be updated")
//        //            }
//        //        }
//
//        func createMapAnnotation(){
//            let annotation = MKPointAnnotation()
//            annotation.coordinate.latitude = self.latitude
//            annotation.coordinate.longitude = self.longitude
//            annotation.title = location
//            self.mapView.addAnnotation(annotation)
//
//            self.mapView.setCenter(annotation.coordinate, animated: true) //--> to place pin the center of the mapView
//            let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //-> create geographical region display. binalar, parklar vs.
//            self.mapView.setRegion(region, animated: true)
//        }
//
//
//        //        func findGeocode(_ address: String) {
//        //            setActivityIndicator(true)
//        //            CLGeocoder().geocodeAddressString(address) { (placemark, error)
//        //                in
//        //                if error == nil {
//        //
//        //                    if let placemark = placemark?.first,
//        //                       let location = placemark.location {
//        //                        self.latitude = location.coordinate.latitude
//        //                        self.longitude = location.coordinate.longitude
//        //
//        //                        print("Latitude:\(self.latitude), Longitude:\(self.longitude)")
//        //
//        //                        self.performSegue(withIdentifier: "SearchLocationSegue", sender: nil)
//        //                    }
//        //
//        //                }else {
//        //                    let alert = UIAlertController(title: "Error", message: "Geocode could not be found. Try again please", preferredStyle: .alert)
//        //                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        //                    alert.addAction(action)
//        //                    self.present(alert, animated: true, completion: nil)
//        //                    print("geocode error")
//        //                }
//        //                self.setActivityIndicator(false)
//        //            }
//        //        }
//        //    }
//
//        func searchLocation(){
//            let searchRequest = MKLocalSearch.Request()
//            searchRequest.naturalLanguageQuery = locationRetrieved
//            let search = MKLocalSearch(request: searchRequest)
//            search.start { (response, error) in
//                guard let response = response else {
//                    let alertVC = UIAlertController(title: "Location not found.", message: "Please input another location.", preferredStyle: .alert)
//                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true)}))
//                    self.present(alertVC, animated: true, completion: nil)
//                    return
//                }
//
//                let pin = MKPointAnnotation()
//                pin.coordinate = response.mapItems[0].placemark.coordinate
//                pin.title = response.mapItems[0].name
//                self.mapView.addAnnotation(pin)
//                self.mapView.setCenter(pin.coordinate, animated: true)
//                let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                self.mapView.setRegion(region, animated: true)
//            }
//        }
//
//        func handlePublicUserData(firstName: String?, lastName: String?, error: Error?) {
//            if error == nil {
//
//                UdacityClient.postStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.locationRetrieved, mediaURL: self.urlRetrieved, latitude: Float(self.latitude), longitude: Float(self.longitude), completion: handlePostStudentResponse(success:error:))
//
//            } else {
//                showFailure(title: "There was an error!", message: error?.localizedDescription ?? "")
//            }
//        }
//
//
//        func handlePostStudentResponse(success: Bool, error: Error?) {
//
//            if success {
//                let mainTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
//                self.present(mainTabController, animated: true, completion: nil)
//
//
//
//            } else {
//                showFailure(title: "Unable to Save Information", message: error?.localizedDescription ?? "")
//            }
//
//        }
//
//        func showFailure(title: String, message: String) {
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        }
//
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    @IBAction func finishButtonTapped(_ sender: Any) {
        setActivityIndicator(true)
        UdacityClient.getUserData(completion:  handlePublicUserData(firstName:lastName:error:))
    }
    
    func handlePublicUserData(firstName : String?, lastName : String? , error : Error? ){
        if error == nil {
            UdacityClient.postStudentLocation(firstName: firstName ?? "", lastName: lastName ?? "", mapString: location, mediaURL: url, latitude: Float(latitude), longitude: Float(longitude), completion: handlePostStudentLocation(success:error:))
        } else {
            print("User data cannot be handled")
        }
        }
    
    func handlePostStudentLocation(success: Bool, error: Error?){
        setActivityIndicator(false)
        if success {
            UdacityClient.User.location = location
            print(UdacityClient.User.location)
            UdacityClient.User.url = url
            print("student added")
            navigationController?.popToRootViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Error", message: "Student could not added. Try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            print("student could not be added.")
        }
    }
    func createMapAnnotation (){
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        annotation.title = location
        mapView.addAnnotation(annotation)
        
        self.mapView.setCenter(annotation.coordinate, animated: true) //--> to place pin the center of the mapView
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)

        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if  pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func setActivityIndicator(_ running : Bool){
        
        if running {
            DispatchQueue.main.async {
                self.activityIndicatorView.startAnimating()
            }
        }else {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        finishButton.isEnabled = !running
        activityIndicatorView.isHidden = !running
    }
    
    }
    
