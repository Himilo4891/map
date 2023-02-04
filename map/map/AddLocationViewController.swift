
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assing delegate of MapView
        self.mapView.delegate = self
        
        //Hide activity indicatory when stops
        activityIndicatorView.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Generate the point in the map when the view appear
     
    }
    override func viewWillAppear(_ animated: Bool) {
            self.mapView.alpha = 0.0
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.mapView.alpha = 1.0
            })
            
        }
        
    @objc func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                if let toOpen = view.annotation?.subtitle! {
                    UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
        
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            
            if pinView == nil {
                pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
        
        
        @IBAction func finishButtonPressed(_ sender: Any) {
            UdacityAPI.getPublicUserData(completion: handlePublicUserData(firstName:lastName:error:))
            
        }
        
        
        
        
        func searchLocation(){
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = LocationResults
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response = response else {
                    let alertVC = UIAlertController(title: "Location not found.", message: "Please input another location.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true)}))
                    self.present(alertVC, animated: true, completion: nil)
                    return
                }
                
                let pin = MKPointAnnotation()
                pin.coordinate = response.mapItems[0].placemark.coordinate
                pin.title = response.mapItems[0].name
                self.mapView.addAnnotation(pin)
                self.mapView.setCenter(pin.coordinate, animated: true)
                let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
            }
        }
        
        func handlePublicUserData(firstName: String?, lastName: String?, error: Error?) {
            if error == nil {
                
                UdacityAPI.PostStudentLocation(firstName: firstName!, lastName: lastName!, mapString: self.locationRetrieved, mediaURL: self.urlRetrieved, latitude: self.latitude, longitude: self.longitude, completion: handlePostStudentResponse(success:error:))
                
            } else {
                showFailure(title: "There was an error!", message: error?.localizedDescription ?? "")
            }
        }
        
        func handlePostStudentResponse(success: Bool, error: Error?) {
            
            if success {
                let mainTabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                self.present(mainTabController, animated: true, completion: nil)
                
                
                
            } else {
                showFailure(title: "Unable to Save Information", message: error?.localizedDescription ?? "")
            }
            
        }
        
        func showFailure(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        
    }
 
