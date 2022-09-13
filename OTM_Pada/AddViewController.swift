

//
//  AddViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/7/22.
//

import Foundation
import UIKit
import CoreLocation

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var Website: UITextField!
    @IBOutlet weak var Submit: UIButton!
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
        override func viewDidLoad() {
        super.viewDidLoad()
        Location.delegate = self
        Website.delegate = self
            }
    
// when submit button is pushed
    @IBAction func submitButtonTapped(_ sender: Any) {
        //function checks for URL validity
        guard let url = URL(string: self.Website.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlertAction(title: "Error", message: "Your URL is invalid. Please try again.")
            return
        }
        initializeNewObject()
        
    }
    
    func initializeNewObject (){
        //and creates the new object for the new student inputted data
        let studentLocation = Locations(objectId:
        DataClient.Auth.tokenRequest,
        uniqueKey: DataClient.Auth.key,
        firstName: DataClient.Auth.firstName,
        lastName: DataClient.Auth.lastName,
        mapString: Location.text ?? "",
        mediaURL: Website.text ?? "",
        latitude: 0,
        longitude: 0
        )
        // calls the geocode function to go through the new object
        geocode(studentLocation)
    }
   
    
    func geocode(_ location: Locations) {
    
        CLGeocoder().geocodeAddressString(location.mapString) { [self] (placemark, error) in
            guard error == nil else {
                let newLocation = self.Location.text
                let url = self.Website.text!
                // if any of these fields are empty, push an error message
                if newLocation!.isEmpty || url.isEmpty {
                    self.showAlertAction(title:"Error", message: "All fields are required. Enter information and please try again")
                            return
                        }
                self.showAlertAction(title: error!.localizedDescription, message: "Location Not Found")
                    // if the app cant find the location, an error is sent
                return
            }
            // similar logic to the map view
            // // with help from Udacity mentors https://knowledge.udacity.com/questions/897019
            // and https://knowledge.udacity.com/questions/897042
            let coordinates = placemark?.first?.location?.coordinate
            var studentLocation = location
            studentLocation.longitude = coordinates!.longitude
            studentLocation.latitude = coordinates!.latitude
            self.performSegue(withIdentifier: "toMap", sender: studentLocation)
        }
    }
    
// https://developer.apple.com/documentation/uikit/uiviewcontroller/1621490-prepare
    // https://classroom.udacity.com/nanodegrees/nd003/parts/4674db75-a1fd-4134-aedf-387f74357fe0/modules/480a4cc0-6e64-4979-b1e6-15ce588850ee/lessons/751f4590-576f-4091-aa8b-3b0edd2cd3e8/concepts/02e40100-74b8-4047-88e3-0d2a4258156b
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let controller = segue.destination as! ConfirmLocationViewController
            controller.newlocation = (sender as! Locations)
        }
    }

}
