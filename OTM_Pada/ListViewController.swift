//
//  ListViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    var studentsList = [Locations]()
    
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
    // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/fc5df54d-bcd3-4cb4-8476-cc9a922ec21c
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
    // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/e3b146dd-c487-4915-8d91-7816fe67d243
    // pulling the logout function from the client
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: self.handleLogoutRequest(success:error:))
    }
    
    // similar logic to pulling the login func from the client
    func generateList() {
        DataClient.getStudentLocations {students, error in
            self.studentsList = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //from Udacity Lession 8.8 Setup the Sent Memes Collection View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsList.count // get the number of students in the data
    }
    //from Udacity Lession 8.8 Setup the Sent Memes Collection View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let student = studentsList[indexPath.row]
        cell.textLabel?.text = "\(String(describing: student.firstName))" + " " + "\(String(describing: student.lastName))" 
        return cell
    }
    
    // from https://knowledge.udacity.com/questions/757434
    func loadLink(url: String){
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url)
        else {
            showAlertAction(title: "Invalid URL", message: "This URL is invalid and could not be opened.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentsList[indexPath.row]
        // from https://knowledge.udacity.com/questions/757434
        loadLink(url: student.mediaURL ?? "")
}
}
