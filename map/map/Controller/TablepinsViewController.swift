
import Foundation
import UIKit

class TablePinsViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set datasource and delegate of tableview
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Reload data when view will appear
        tableView.reloadData()
    }
    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
    func showAlert(ofType type: AlertNotification.ofType, message: String){
        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    //MARK: - refresh: Refresh data from new retrieved user locations
    public func refresh(){
        if let tableView = tableView{
            tableView.reloadData()
        }
    }
}

extension TablePinsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell", for: indexPath)
        let studentInfo = StudentLocation.data[indexPath.row]
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let mediaURL = StudentLocation.data[indexPath.row].mediaURL
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Check if the URL format is correct if not set an alert
        if mediaURL.contains("https"){
            if let mediaURL = URL(string: mediaURL){
                UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            }
        } else {
            showAlert(ofType: .incorrectURLFormat, message: "Media contains a wrong URL format")
        }
    }
}
