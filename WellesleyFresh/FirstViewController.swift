//
//  NearbyViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 9/8/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//
// https://www.youtube.com/watch?v=Z272SMC9zuQ&ab_channel=BrianAdvent

//
//  ViewController.swift
//  WellesleyFreshMapDemo
//
//  Created by Audrey Seo on 9/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit
import MapKit

class NearbyViewController: UIViewController, CLLocationManagerDelegate {
	var coreLocationManager = CLLocationManager()
	var first = true
	
	@IBOutlet weak var mapViewer: MKMapView!
	
	@IBOutlet weak var locationInfo: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		coreLocationManager.delegate = self
		
		let authorizationCode = CLLocationManager.authorizationStatus()
		
		if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestWhenInUseAuthorization"){
			print("Authorization not determined...")
			if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil {
				coreLocationManager.requestWhenInUseAuthorization()
			} else {
				print("No description provided")
			}
		} else {
			self.getInitialLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Failed with an error")
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Updated location")
		let last = locations.count - 1
		
		displayLocation(locations[last])
	}
	
	func getLocation() {
		print("Getting location")
		coreLocationManager.startMonitoringSignificantLocationChanges()
	}
	
	func getInitialLocation() {
		print("Setting the initial location")
		coreLocationManager.requestLocation()
	}
	
	func displayLocation(location:CLLocation) {
		mapViewer.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
		
		let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		let annotation = MKPointAnnotation()
		annotation.coordinate = locationPinCoord
		
		mapViewer.addAnnotation(annotation)
		mapViewer.showAnnotations([annotation], animated: true)
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted {
			if (first) {
				first = false
				getInitialLocation()
			} else {
				getLocation()
			}
		}
	}
	
	@IBAction func updateLocation(sender: AnyObject) {
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

