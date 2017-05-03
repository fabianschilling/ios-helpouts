//
//  MapViewController.swift
//  Helpouts
//
//  Created by Fabian Schilling on 5/3/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Class Variables
    
    var location: CLLocation!
    var annotationTitle: String! {
        didSet {
            addAnnotation()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        addAnnotation()
    }
    
    // MARK: View Setup
    
    func addAnnotation() {
        if mapView != nil {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = annotationTitle
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView!, didUpdate userLocation: MKUserLocation!) {
        let myPoint = MKMapPointForCoordinate(userLocation.coordinate)
        let userPoint = MKMapPointForCoordinate(location.coordinate)
        
        let myRect = MKMapRectMake(myPoint.x, myPoint.y, 0, 0)
        let userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0)
        
        let unionRect = MKMapRectUnion(myRect, userRect)
        
        let unionRectThatFits = mapView.mapRectThatFits(unionRect)
        
        mapView.setVisibleMapRect(unionRectThatFits, animated: true)
        
        //let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        //mapView.setRegion(region, animated: false)
        mapView.delegate = nil // dont want more location updates
    }

}
