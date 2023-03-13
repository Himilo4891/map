//
//import Foundation
//import UIKit
//
//class TablePinsViewController: UIViewController {
//    
//    //IBOutlets
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //Set datasource and delegate of tableview
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //Reload data when view will appear
//        tableView.reloadData()
//    }
//    //MARK: - showAlert: Create an alert with dynamic titles according to the type of error
//    func showAlert(ofType type: AlertNotification.ofType, message: String){
//        let alertVC = UIAlertController(title: type.getTitles.ofController, message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: type.getTitles.ofAction, style: .default, handler: nil))
//        present(alertVC, animated: true)
//    }
//    //MARK: - refresh: Refresh data from new retrieved user locations
//    public func refresh(){
//        if let tableView = tableView{
//            tableView.reloadData()
//        }
//    }
//}
//
//extension TablePinsViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    // MARK: - UITableViewDelegate, UITableViewDataSource
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return StudentLocation.data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell", for: indexPath)
//        let studentInfo = StudentLocation.data[indexPath.row]
//        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
//        cell.imageView?.image = UIImage(named: "icon_pin")
//        return cell
//    }
//    
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let student = st.locations[indexPath.row]
//        guard let url = URL(string: student.mediaURL!) else {return}
//        
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        
//    }
//    
//    
//    func showAlert(){
//        let alert = UIAlertController(title: "Warning", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
//            if let vc = self.storyboard?.instantiateViewController(identifier: "AddLocationViewController") as? AddLocationViewController {
//                vc.loadView()
//                self.tabBarController?.tabBar.isHidden = true
//                vc.urlTextField.text = UdacityClient.User.url
//                vc.locationTextField.text = UdacityClient.User.location
//                self.navigationController?.pushViewController(vc, animated: true)
//                
//            }else{
//                fatalError("alert error")
//            }
//        }
//        
//        let okACtion2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(okAction)
//        alert.addAction(okACtion2)
//        present(alert, animated: true, completion: nil)
//    }
//
//}
//
