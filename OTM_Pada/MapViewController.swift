//
//  MapViewController.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/5/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var locations = [Locations]()
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var Map: MKMapView!


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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        generateMap()
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
    
    // with help from Udacity mentors https://knowledge.udacity.com/questions/897019
    // and https://knowledge.udacity.com/questions/897042
    class StudentsLocationArray {
        static var students = [Locations]()
    }
    
    func getStudentsPins() {
        let annotations = [MKPointAnnotation]()
        for student in StudentsLocationArray.students {
          let pin = MKPointAnnotation()
          pin.title = student.firstName ?? ""
          pin.subtitle = student.mediaURL ?? ""
          pin.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
            self.Map.addAnnotation(pin)
        }
    }
    
    func generateMap() {
        DataClient.getStudentLocations { (locations, error) in
            if error == nil {
                DispatchQueue.main.async {
                    StudentsLocationArray.students = locations ?? []
                    self.getStudentsPins()
                }
            } else {
                self.showAlertAction(title:"Error", message: "Please try again.")
            }
        }
    }
    
    // MARK: Map view data source
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }

}

