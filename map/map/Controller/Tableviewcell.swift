
import UIKit
import MapKit
import CoreLocation

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var iconPin: UIImageView!
    @IBOutlet weak var mediaURL: UILabel!
}

class MapTableViewController: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var results = [StudentInformation]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        UdacityClient.getStudentsLocations { studentlocationresults, error in
            
        }
                                         }
    @IBAction func refreshButtonPRessed(_ sender: Any) {
        UdacityClient.getStudentsLocations { studentlocationresults, error in
            
            StudentModel.locations = studentlocationresults
            self.tableView.reloadData()
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.logout {_ in
            self.dismiss(animated: true, completion: nil)
            
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Failed", message: "Could not log out. Try again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.studentName?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].firstName + " " + appDelegate.studentLocations[(indexPath as NSIndexPath).row].lastName
        cell.mediaURL?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let app = UIApplication.shared
        if let toOpen = tableCell.mediaURL?.text! {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    @IBAction func addLocation(_ sender: Any) {
        if UdacityClient.User.createdAt == ""{
            performSegue(withIdentifier: "toInformationVC", sender: nil)
        } else {
            showAlert()
        }
    }
    
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(ofType: "Logout Failed", message: "An Error has occured. Try again.")
        }
    }
    
  
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        refreshButton.isEnabled = true
        
        if error == nil {
            appDelegate.studentLocations = locations
            self.tableView.reloadData()
        } else {
            showAlert(ofType: "No location found", message: error?.localizedDescription ?? "")
        }
    }
        
    func showAlert(ofType: String, message: String){
        let alertController = UIAlertController(title: "Warning", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "toInputVC") as? PostingViewController{
                
                vc.loadView()
                vc.viewDidLoad()
                vc.mediaURLText.text = UdacityClient.User.link
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
    }
