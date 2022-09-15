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
    override func viewDidLoad() {
        super.viewDidLoad()
        // from https://knowledge.udacity.com/questions/208820
        // to make pins look like rubric and open links
        self.Map.delegate = self

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
    
    // with help from Udacity mentors https://knowledge.udacity.com/questions/897019
    // and https://knowledge.udacity.com/questions/897042
    class StudentsLocationArray {
        static var students = [Locations]()
    }
    
    // with help from Udacity mentors https://knowledge.udacity.com/questions/897019
    // and https://knowledge.udacity.com/questions/897042
    func generatePins() {
        Map.removeAnnotations(Map.annotations)
        let annotations = [MKPointAnnotation]()
        for student in StudentsLocationArray.students {
          let pin = MKPointAnnotation()
        pin.title = student.firstName + " " + student.lastName
          pin.subtitle = student.mediaURL ?? ""
          pin.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
            self.Map.addAnnotation(pin)
        }
    }
    // help from https://knowledge.udacity.com/questions/897042
    func generateMap() {
        DataClient.getStudentLocations { (locations, error) in
            if error == nil {
                DispatchQueue.main.async {
                    StudentsLocationArray.students = locations ?? []
                    self.generatePins()
                }
            } else {
                self.showAlertAction(title:"Error", message: "Please try again.")
            }
        }
    }
     
    
    // makes the pins look like the ones on the rubric
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
    // from https://knowledge.udacity.com/questions/757434
    func loadLink(url: String){
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url)
        else {
            showAlertAction(title: "Invalid URL", message: "This URL is invalid and could not be opened.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

// interacting with the map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let insertedURL = view.annotation?.subtitle! {
                // from https://knowledge.udacity.com/questions/757434
                loadLink(url: insertedURL)
            }
        }
    }
    
    }
