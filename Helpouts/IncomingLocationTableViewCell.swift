//
//  IncomingLocationTableViewCell.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/1/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import MapKit

class IncomingLocationTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    var location: CLLocation! {
        didSet {
            addAnnotation(location)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.layer.cornerRadius = 15
            mapView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var mapButton: MapButton!
    
    
    
    func addAnnotation(_ location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
        
        // setting visible rect
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
        mapView.regionThatFits(region)
    }
}
