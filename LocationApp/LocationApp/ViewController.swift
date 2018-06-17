//
//  ViewController.swift
//  LocationApp
//
//  Created by Zun Lin on 6/14/18.
//  Copyright © 2018 Zun Lin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //Outlet Variables
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentButton: UIBarButtonItem!
    @IBOutlet weak var addGeoButton: UIBarButtonItem!
    //Instance Variables
    let locationManager = CLLocationManager()
    var geoFenceRegion = CLCircularRegion()
    var coordinate = CLLocationCoordinate2D()
    var radius: Double = 0.0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        moveToCurrent(currentButton)
        coordinate = CLLocationCoordinate2DMake(37.545765, -77.448982)
        radius = 50.0
        geoFenceRegion = CLCircularRegion(center: coordinate, radius: radius, identifier: "Cross Section")
        addRadiusOverlay(coordinate: coordinate, radius: radius)
        locationManager.startMonitoring(for: geoFenceRegion)

    }
    
    @IBAction func moveToCurrent(_ sender: Any) {
        print("pressed current location button")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        print(currentLocation.coordinate)
        let span = MKCoordinateSpanMake( 0.0005, 0.005)

        let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)

        mapView.setRegion(region, animated: true)

        self.mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")

    }
    func addRadiusOverlay(coordinate: CLLocationCoordinate2D, radius: Double) {
        mapView?.add(MKCircle(center: coordinate, radius: radius))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

