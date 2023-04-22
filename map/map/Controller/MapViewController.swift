


import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
//    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var MapView: MKMapView!
    
    
        var annotations = [MKPointAnnotation]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MapView.delegate = self
        Pins()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Pins()
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
        if UdacityClient.User.createdAt == ""{
            performSegue(withIdentifier: "PostingViewController", sender: nil)
        } else {
            Pins()        }
    }
    
    @IBAction func refershButton(_ sender: Any) {
        Pins()
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { error in
            if ((error) != nil) {
                self.dismiss(animated: true, completion: nil)
                print("logged out")
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed", message: "Could not log out. Try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func showAlert(ofType: String, message: String) {
        let alertController = UIAlertController(title: "Warning", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "toInputVC") as? PostingViewController{
                
                vc.loadView()
                vc.viewDidLoad()
                vc.mediaURLText.text = UdacityClient.User.url
                vc.LocationText.text = UdacityClient.User.location
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                fatalError("alert error")
            }
        }
        let okAction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        present(alertController, animated: true, completion: nil)
        
    }
    func Pins(){
        //        data that you can download from parse.
        UdacityClient.getStudentsLocation { studentlocationresults, error in
            
            if error == nil {
                StudentModel.locations = studentlocationresults
                
                var annotations = [MKPointAnnotation]()
                
                for student in StudentModel.locations {
                    
                    let lat = CLLocationDegrees(student.latitude )
                    let long = CLLocationDegrees(student.longitude)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D( latitude:lat, longitude: long)
                    annotation.title = "\(student.firstName)" + " " + "\(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    annotations.append(annotation)
                    self.MapView.addAnnotation(annotation)
                }
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Data couldn't load", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //Method implemented to respond to taps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.canOpenURL(URL(string: toOpen)!)
                app.open(URL(string: toOpen)!)

            }
        }
    }
}

