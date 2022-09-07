//
//  ListViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    var students = [Locations]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.generateList()
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.generateList()
    }
    
    // from https://stackoverflow.com/questions/24195310/how-to-add-an-action-to-a-uialertview-button-using-swift-ios
    
    // stack overflow said to use DispatchQueue: https://stackoverflow.com/questions/58087536/modifications-to-the-layout-engine-must-not-be-performed-from-a-background-thr
        
    func showAlertAction(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // logout function
    func handleLogoutRequest(success: Bool, error: Error?) {
        if success { // if deleting the session works, dismiss the screen
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else { // if it doesn't work, show an error
            showAlertAction(title:"Error", message: "Could not logout. Please try again.")
        }
    }
    // pulling the logout function from the client
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: self.handleLogoutRequest(success:error:))
    }
    
    // MARK: Get list of students
    // source?
    func generateList() {
        DataClient.getStudentLocations {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count // get the number of students in the data
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        // input the data into the cell
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)" // show the data based on the labels
        cell.detailTextLabel?.text = "\(student.mediaURL )" // show the URL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
       // openLink(student.mediaURL ?? "")
    }
    
}
