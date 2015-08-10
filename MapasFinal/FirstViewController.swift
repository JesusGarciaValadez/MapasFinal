//
//  FirstViewController.swift
//  MapasFinal
//
//  Created by Jesús García Valadez on 09/08/15.
//  Copyright © 2015 Jesús García Valadez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    var coordinate: CLLocationCoordinate2D!

    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager( manager manager: CLLocationManager!, didFailWithError error: NSError! ) {
        locationManager.stopUpdatingLocation()
        if let _ = error {
            if seenError == false {
                seenError = true
                print( error )
            }
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationFixAchieved == false {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            self.coordinate = locationObj.coordinate

            print( self.coordinate.latitude )
            print( self.coordinate.longitude )
        }
    }

    // Authorization Status
    func locationManager( manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus ) {
        var shouldIAllow = false

        switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denued acccedd to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowes to location Access"
                shouldIAllow = true
        }

        NSNotificationCenter.defaultCenter().postNotificationName( "LabelHasbeenUpdated", object: nil )
        if shouldIAllow == true {
            NSLog( "Location to Allowed" )
            locationManager.startUpdatingLocation()
        } else {
            NSLog( "Denied access" )
        }
    }

    @IBOutlet var map: MKMapView!
    @IBAction func checkIn(sender: UIButton) {
        let alert = UIAlertController( title: "Ubicación", message: "\( self.coordinate.longitude ) \( self.coordinate.latitude )", preferredStyle: UIAlertControllerStyle.Alert )

        alert.addAction( UIAlertAction( title: "Hacer Check In", style: UIAlertActionStyle.Default, handler: nil ) )

        self.presentViewController( alert, animated: true, completion: nil )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.initLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

