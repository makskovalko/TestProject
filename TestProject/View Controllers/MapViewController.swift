//
//  MapViewController.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!
    
    var coordinate: CityData.Coordinate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = false
        showCoordinateOnMap()
        
        navigationItem.title = "Map"
    }
    
    private func showCoordinateOnMap() {
        guard let coordinate = coordinate else { return }
        
        let coord = CLLocationCoordinate2D(
            latitude: coordinate.lat,
            longitude: coordinate.lon
        )
        
        mapView.centerCoordinate = coord
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
    }

}
