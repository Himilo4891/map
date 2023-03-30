//
//  Table Top.swift
//  map
//
//  Created by abdiqani on 01/02/23.
//
//
//import Foundation
//import UIKit
//class Table: UIViewController {
//
//
//    override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view.
//        }
//
//    @IBAction func Logout(_ sender: Any) {
//        Table.logOut()
//    }
//
//    @IBAction func add(_ sender: Any) {
//
//    }
//}

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: - refreshLocation: Get new data and save it
    @IBAction func refreshLocation(_ sender: Any) {
        UdacityClient.getStudentsLocationData(completionHandler: handleRefreshStudentsLocation(location:error:))
    }
    //MARK: - logout: Send a logout request when button is pressed
    @IBAction func logout(_ sender: Any) {
        UdacityClient.Logout(completionHandler: handleLogout(error:))
    }
    //MARK: - handleLogout: If the response was 200 then dismiss the view
    func handleLogout(error: Error?){
        if error == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - handleRefreshStudentsLocation: If data was retrieved save it and refresh in tabBar Children the data
    func handleRefreshStudentsLocation(location: [StudentInformation], error: Error?){
        if let error = error{
            showAlert(ofType: .retrieveUsersLocationFailed, message: error.localizedDescription)
        }else {
            StudentsLocation.data = location
        }
        
        for childViewController in self.children {
            if let mapViewController = childViewController as? MapViewController{
                mapViewController.refresh()
            }else if let tableViewController = childViewController as? TablePinsViewController{
                tableViewController.refresh()
            }
        }
    }
    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
    func showAlert(ofType type: AlertNotification.ofType, message: String){
           let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
           show(alertVC,sender: nil)
    }
}
