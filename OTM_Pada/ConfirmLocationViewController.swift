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
    var location: Locations?

    @IBOutlet weak var MapView: MKMapView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: New location in map
    
    private func showLocations(location: UpdatedLocation) {
        MapView.removeAnnotations(MapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            MapView.addAnnotation(annotation)
            MapView.showAnnotations(MapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: UpdatedLocation) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    }
    
