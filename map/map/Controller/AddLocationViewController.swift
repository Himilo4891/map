
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
    
