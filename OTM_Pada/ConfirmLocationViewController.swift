//
//  ConfirmLocation.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/8/22.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate{
    
    var newlocation: Locations?
    var userdata: DataFromUsers?
    
    @IBOutlet weak var MapView: MKMapView!
    
    // MARK: Life Cycle
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
        self.MapView.delegate = self
        pullLocation()
        // from https://knowledge.udacity.com/questions/208820
        // to make pins look like rubric and open links
    }
    // pulling the location from the previous screen
    func pullLocation(){
        if let studentLocation = newlocation {
            let studentLocation = UpdatedLocation(
                firstName: studentLocation.mapString,
                lastName: studentLocation.mediaURL,
                mapString: studentLocation.objectId ,
                mediaURL: studentLocation.uniqueKey,
                objectId: studentLocation.firstName,
                uniqueKey: studentLocation.lastName,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude
            )
            showLocations(location: studentLocation)
            // calling function using new object
        }
    }
    // displaying the locations on the actual map
    private func showLocations(location: UpdatedLocation) {
        var annotations = [MKPointAnnotation]()
        guard let addedLocation = newlocation else { return }
        let coordination = CLLocationCoordinate2D(latitude: addedLocation.latitude, longitude: addedLocation.longitude)
        // similar logic to the map view
        // // with help from Udacity mentors https://knowledge.udacity.com/questions/897019
        // and https://knowledge.udacity.com/questions/897042
        let annotation = MKPointAnnotation()
        annotation.title = userdata?.firstName
        annotation.subtitle = location.mediaURL ?? ""
        annotation.coordinate = coordination
        // from https://knowledge.udacity.com/questions/898371
        MapView.addAnnotation(annotation)
        MapView.showAnnotations(MapView.annotations, animated: true)
    }
    // submit button pressed
    @IBAction func Submit(_ sender: Any) {
        if let updatedLocation = newlocation {
            if DataClient.Auth.tokenRequest == "" {
                DataClient.addLocation(information: updatedLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
                            func goBack() {
                                _ = self.navigationController?.popViewController(animated: true)
                                _ = self.navigationController?.popViewController(animated: true)
                                return
                            }
                            goBack()
                            return
                        }
                    }
                    if (error != nil) {
                        DispatchQueue.main.async {
                            self.showAlertAction(title: "Error!", message: "Something went wrong. Please try again.")
                        }
                    }
                }
            }
        }
    }
}
