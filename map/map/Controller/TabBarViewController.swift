
import UIKit
import MapKit
import CoreLocation

class TabBarViewController: UITabBarController {
    
        //MARK: - refreshLocation: Get new data and save it
    @IBAction func refreshLocation(_ sender: Any) {
            UdacityClient.getStudentsLocationData(completionHandler: handleRefreshStudentsLocation(location:error:))
        }
        //MARK: - logout: Send a logout request when button is pressed
    @IBAction func logout(_ sender: Any) {
            UdacityClient.logout(completionHandler: handleLogout(error:))
        }
        //MARK: - handleLogout: If the response was 200 then dismiss the view
    func handleLogout(error: Error?){
            if error == nil {
                dismiss(animated: true, completion: nil)
            }
        }
        
    func handleRefreshStudentsLocation(location: [StudentInformation], error: Error?){
            if let error = error{
                showAlert(ofType: .retrieveUsersLocationFailed, message: error.localizedDescription)
            }else {
                StudentLocation.data = location
            }
            
            for childViewController in self.children {
                if let mapViewController = childViewController as? MapViewController{
                    mapViewController.refresh()
                }else if let tableViewController = childViewController as? TablePinsViewController{
                    tableViewController.refresh()
                }
            }
        }
        
        func showAlert(ofType type: AlertNotification.ofType, message: String){
               let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
               alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
               show(alertVC,sender: nil)
        }
    }
