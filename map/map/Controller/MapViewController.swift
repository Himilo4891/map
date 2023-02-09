

import Foundation

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var annotations = [MKPointAnnotation]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        generateAnnotations()
        
    }
    func showAlert(ofType type: AlertNotification.ofType, message: String){
        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    public func refresh(){
        self.mapView.removeAnnotations(mapView.annotations)
        generateAnnotations()
    }
    
    func generateAnnotations(){
        
        var annotations = [MKPointAnnotation]()
        
        for student in StudentLocation.data {
            let lat = CLLocationDegrees(student.latitude )
            let long = CLLocationDegrees(student.longitude )
       
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            
            var fullName = ""
            if first == "" && last == ""{
                fullName = "No Name"
            }
            else if first == ""{
                fullName =  last
            }
            else if last == ""{
                fullName = first
            }
            else{
                fullName = "\(first) \(last)"
            }
            
          
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = fullName
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
            
            
        }
        self.mapView.addAnnotations(annotations)
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
            if let mediaURL = view.annotation?.subtitle! {
                if mediaURL.contains("https"){
                    if let mediaURL = URL(string: mediaURL){
                        UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
                    }
                    
                }
            }
            
        }
    }
    
}
