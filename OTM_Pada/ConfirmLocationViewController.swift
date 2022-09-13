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
                objectId: studentLocation.objectId ,
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
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
    
    
    @IBAction func SubmitButtonPushed(_ sender: Any) {
        if let studentLocation = newlocation {
            if DataClient.Auth.tokenRequest == "" {
                DataClient.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlertAction(title: "Error", message: "Error")
                        }
                    }
                }
            }
        }
        
    // to make the pin look as it does on the rubric
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            return pinView
        }
        
    }
    
    
}
