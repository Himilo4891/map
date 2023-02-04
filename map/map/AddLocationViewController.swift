
import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    //Properties
    var mapString: String!
    var mediaURL: String!
    var geoLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assing delegate of MapView
        self.mapView.delegate = self
        
        //Hide activity indicatory when stops
        activityIndicatorView.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Generate the point in the map when the view appear
        generatePointInMap()
    }
    //MARK: - submitLocation: Submit the obtained point to Udacity's servers
    @IBAction func submitLocation(_ sender: Any) {
        isPostingLocation(true)
        UdacityClient.createStudentLocation(mapString: mapString, mediaURL: mediaURL, coordinates: (geoLocation.latitude,   geoLocation.longitude), completionHandler: handleCreateLocationResponse(success:error:))
    }
    //MARK: centerMapOnLocation: Zoom in to the coordinates entered by user
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //MARK: - generatePointInMap: Generate the annotation for the location entered
    func generatePointInMap(){
        
        var annotations = [MKPointAnnotation]()

        let lat = CLLocationDegrees(geoLocation.latitude)
        let long = CLLocationDegrees(geoLocation.longitude)

        // The lat and long to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        // Place the annotation in an array of annotations.
        annotations.append(annotation)

        // When the array is complete, add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
        centerMapOnLocation(CLLocation(latitude: lat, longitude: long), mapView: mapView)
    }
    //MARK: - handleCreateLocationResponse: If successful dismiss the view if not show alert
    func handleCreateLocationResponse(success: Bool, error: Error?){
        if success {
            isPostingLocation(false)
            
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(ofType: .createLocationFailed, message: error?.localizedDescription ?? "")
        }
    }
    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
    func showAlert(ofType type: AlertNotification.ofType, message: String){
        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
        present(alertVC, animated: true)
        isPostingLocation(false)
    }
    
    //MARK: - isPostingLocation: Control the activityViewIndicatior when to start and stop animating
    func isPostingLocation(_ hasPosted: Bool){
        if hasPosted{
            activityIndicatorView.startAnimating()
        }else{
            activityIndicatorView.stopAnimating()
        }
        finishButton.isEnabled = !hasPosted
    }

}

extension AddLocationViewController: MKMapViewDelegate{

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
