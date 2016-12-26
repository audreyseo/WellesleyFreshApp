//
//  FirstViewController.swift
//  WellesleyFresh
//
//	Provides the nearest dining halls to the user, and shows the dining halls as annotations on
//	a map. This is the first tab in the app.
//
//  Created by Audrey Seo on 9/8/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//
// https://www.youtube.com/watch?v=Z272SMC9zuQ&ab_channel=BrianAdvent


import UIKit
import MapKit

class FirstViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
	var coreLocationManager = CLLocationManager()
	var chosenDiningHall = ""
	var chosenShort = ""
	var first = true
	var latitudes = [42.294580,42.291953,42.292747,42.291104,42.295818]
	var longitudes = [-71.308941,-71.300282,-71.308737,-71.302814,-71.307396]
	// Leaky beaker: 42.293866, -71.302857,
	let diningHalls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy"]
	var names = ["Bao Pao Lu Chow", "Bates", "Tower", "Stone Davis", "Pomeroy"]
//	var names = ["Stone-Davis Dining", "Bates Dining","The Leaky Beaker", "The Lulu", "Pomeroy", "Tower"]
	var menus = [String:[String]]()
	let diningHallDictionaryKey = "diningHallDictionaryKey"
	let todaysDateKey = "todaysDateKey"
	
	var diningHallAnnotations:[MKPointAnnotation] = [MKPointAnnotation]();
	
	var hallPicker:UIPickerView = UIPickerView()
	let hallToolBar:UIToolbar = UIToolbar()
	let hallInputView:UIInputView = UIInputView()
	
	let storedData:NSUserDefaults = NSUserDefaults()
	var diningHallNames:[String] = ["", "", ""]
	var diningHallNamesShort:[String] = ["", "", ""]
	var items:[String] = []
	var barButtonDone:UIBarButtonItem {
		return UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(madeSelection))
	}
	var barButtonSpace:UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
	}
	var barButtonCancel:UIBarButtonItem {
		return UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(madeSelection))
	}
	
	var tableview:UITableView = UITableView()
	
	@IBOutlet weak var mapViewer: MKMapView!
	
	
	@IBOutlet weak var locationInfo: UILabel!
	
	@IBOutlet weak var closest1: UILabel!
	@IBOutlet weak var showDiningHallName: UILabel!
	@IBOutlet weak var closest2: UILabel!
	@IBOutlet weak var closest3: UILabel!
	@IBAction func showSelector() {
		hallInputView.hidden = false;
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		coreLocationManager.delegate = self
		
		let authorizationCode = CLLocationManager.authorizationStatus()
		
		if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)){
			print("Authorization not determined...")
			if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil {
				coreLocationManager.requestWhenInUseAuthorization()
			} else {
				print("No description provided")
			}
		} else {
			self.getInitialLocation()
		}
		
		tableview.registerClass(MyCell.self, forCellReuseIdentifier: "cellId")
		
		// Assigns the class Header to the type of header cell that we use
		tableview.registerClass(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
		tableview.delegate = self
		tableview.dataSource = self
		
		tableview.sizeToFit()
		
		// ty to this tutorial for the following code for auto-height for cells: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
		tableview.estimatedRowHeight = 140
		
		self.view.addSubview(tableview)
		
		
		hallPicker.hidden = false
		hallPicker.dataSource = self
		hallPicker.delegate = self
		hallPicker.backgroundColor = UIColor.whiteColor()
		hallPicker.showsSelectionIndicator = true
		
		hallToolBar.barStyle = UIBarStyle.Default
		hallToolBar.translucent = true
		
		hallToolBar.setItems([barButtonCancel, barButtonSpace, barButtonDone], animated: false)
		hallPicker.tag = 40
		hallInputView.addSubview(hallToolBar)
		hallInputView.addSubview(hallPicker)
		hallInputView.hidden = true
		hallInputView.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(hallInputView)
		
	}
	
	override func viewWillAppear(animated: Bool) {
		let height = self.view.frame.origin.y + self.view.frame.size.height
		hallPicker.frame = CGRectMake(0, 40, self.view.frame.size.width, 400)
		hallInputView.frame = CGRectMake(0, self.view.frame.origin.y + self.view.frame.size.height - 440, self.view.frame.size.width, 440)
		hallToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40)
		let hLimit = showDiningHallName.frame.origin.y + 30;
		tableview.frame = CGRectMake(0, hLimit, self.view.frame.size.width * 0.95, (height - hLimit) * 0.8)
	}
	
	// --------------------------------------------------------------------
	// ------------------------DELEGATE METHODS----------------------------
	// --------------------------------------------------------------------
	
	// ------------UITableView Delegate and Datasource Methods-------------
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! MyCell
		if (items.count > 0) {
			myCell.nameLabel.text = items[indexPath.row]
		} else {
			myCell.nameLabel.text = ""
		}
		return myCell
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerId") as! Header
//		if (self.chosenDiningHall != "") {
//			myHeader.nameLabel.text = self.chosenDiningHall
//		} else {
			myHeader.nameLabel.text = "Choose a dining hall by clicking the button above."
//		}
		//		myHeader.myTableViewController = self
		return myHeader
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
//	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//		if (indexPath.row >= items.count - 1) {
//			adjustHeightOfTableview()
//		}
//	}
	
	func adjustHeightOfTableview() {
//		let height:CGFloat = CGFloat(items.count * 50);
		var height:CGFloat = 0;
		
		for i in 0...items.count - 1 {
			if (tableview.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) != nil) {
				let cell:MyCell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! MyCell
				height = height + cell.frame.height;
			}
		}
		//		let maxHeight:CGFloat = self.tableView.superview!.frame.size.height - self.tableView.frame.origin.y;
		
		if tableview.contentSize.height != height {
			tableview.contentSize = CGSize(width: tableview.contentSize.width, height: height)
		}
	}
	
	
	// ----------UIPickerView Datasource and Delegate Functions-----------
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 3
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return diningHallNames[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		chosenDiningHall = diningHallNames[row]
		chosenShort = diningHallNamesShort[row]
		print("Selected: ", diningHallNames[row])
	}
	
	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return self.view.frame.size.width * 0.8
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
	
	// -----------------CLLocationManager Delegate Functions-----------------
	// All of these functions react to a certain event.
	
	// Fires when an error happens.
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Failed with an error")
	}
	
	// Fires when the location updates.
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Updated location")
		let last = locations.count - 1
		displayLocation(locations[last])
		manager.stopUpdatingLocation()
	}
	
	// Fires when the authorization status updates.
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted {
			if (first) {
				first = false
				displayDiningHallCenters()
				getInitialLocation()
			} else {
				getLocation()
			}
		}
	}
	
	
	// ------------------------------HELPERS---------------------------------
	
	// Retitles the header of the tableview
	func retitleHeader() {
		if (tableview.headerViewForSection(0) != nil) {
			(tableview.headerViewForSection(0) as! Header).nameLabel.text = self.chosenDiningHall
		}
	}
	
	// Tells the hallInputView to go away
	func madeSelection() {
		showDiningHallName.text = chosenDiningHall
		hallInputView.hidden = true
		let storedDateKey:String = storedData.stringForKey(todaysDateKey)!
		
		var today:NSDate
		today = NSDate.init()
		
		
		// Create a date formatter
		let MyDateFormatter = NSDateFormatter()
		MyDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		MyDateFormatter.dateFormat = "MMdd"
		// Now make a date that represents today - we use this to retrieve the menu for the day
		let todayString:String = MyDateFormatter.stringFromDate(today)
		print(storedDateKey, "vs", todayString)
		
		if (storedDateKey == todayString) {
			menus = storedData.dictionaryForKey(diningHallDictionaryKey) as! [String:[String]]
			newCellsInsertion()
			retitleHeader()
		}
		
	}
	
	// ------------------Functions for Showing New Data-------------------
	
	func newCellsInsertion() {
		var normalArray:[String] = menus[chosenShort]!
		if (normalArray.count >= 1) {
			let originalSize:Int = items.count
			let newSize:Int = normalArray.count
			
			print("Old Size, New Size: ", originalSize, ", ", newSize, separator: "")
			var indexPaths = [NSIndexPath]()
			var originalPaths = [NSIndexPath]()
			var bottomHalfIndexPaths = [NSIndexPath]()
			if (newSize >= originalSize) {
				let isAbsoluteDiffGreaterThanOne:Bool = newSize - originalSize > 1
				for i in 0...normalArray.count - 1 {
					if (i < normalArray.count) {
						if (i < originalSize) {
							items[i] = normalArray[i]
						} else {
							items.append(normalArray[i])
						}
					}
					if (i >= originalSize) {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					} else {
						originalPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
				}
				
				if (isAbsoluteDiffGreaterThanOne) {
					for _ in 0...indexPaths.count / 2 - 1 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
				}
				
				tableview.beginUpdates()
				tableview.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
				if (isAbsoluteDiffGreaterThanOne) {
					tableview.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableview.insertRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
				} else if (newSize - originalSize == 1) {
					tableview.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
				}
				tableview.endUpdates()
				adjustHeightOfTableview()
			} else if (newSize < originalSize) {
				for i in 0...originalSize - 1 {
					
					if (i < newSize) {
						items[i] = normalArray[i]
					} else {
						items.removeLast()
					}
					
					if (i >= newSize) {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					} else {
						originalPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
				}
				
				if indexPaths.count > 2 {
					for _ in 0...indexPaths.count / 2 - 1 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
					
					tableview.beginUpdates()
					tableview.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
					tableview.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableview.deleteRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
					tableview.endUpdates()
					adjustHeightOfTableview()
				} else {
					tableview.beginUpdates()
					tableview.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
					tableview.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableview.endUpdates()
					adjustHeightOfTableview()
				}
			}
		}
	}

	
	// Helper function that calculates distance over a sphere.
	func distance(first:CLLocation, second:CLLocationCoordinate2D) -> Float {
		let lat1 = Float(first.coordinate.latitude)
		let lon1 = Float(first.coordinate.longitude)
		let lat2 = Float(second.latitude)
		let lon2 = Float(second.longitude)
		
		let phi1 = radians(lat1)
		let phi2 = radians(lat2)
		
		let deltaPhi = radians(lat2 - lat1)
		let deltaLambda = radians(lon2 - lon1)
		
		let a = (sin(deltaPhi / 2.0) * sin(deltaPhi / 2.0)) + (cos(phi1) * cos(phi2) * sin(deltaLambda / 2.0) * sin(deltaLambda / 2.0));
		let c = atan(sqrt(a) / sqrt(1 - a)) * 2.0; // Float(M_PI);
		let d = 6371043 * c;
		return d;
	}
	
	// Helper function that converts degrees (latitude, longitude) to radians
	func radians(degrees:Float)->Float {
		return degrees * Float(M_PI / 180.0);
	}
	
	// ---------------------------Get Location-------------------------------
	
	// Asks the coreLocationManager to monitor significant changes in the location.
	func getLocation() {
		print("Getting location")
		coreLocationManager.startMonitoringSignificantLocationChanges()
	}
	
	// Asks for a starting point for our location.
	func getInitialLocation() {
		print("Setting the initial location")
		// Only available in iOS 9.0 or greater
		coreLocationManager.startUpdatingLocation()
		
	}
	
	// -------------------------Get Web Data----------------------------
	
	// Downloads the data from the Wellesley Fresh site in an attempt to get the data.
	func getWellesleyFreshData() {
		let url = NSURL(string: "http://www.wellesleyfresh.com/today-s-menu.html")
		let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
			if error == nil {
				print(NSString(data: data!, encoding: NSUTF8StringEncoding))
			}
		}
		task.resume()
	}
	
	// --------------------Configure dining hall annotations------------------------
	
	// Create all of the dining hall annotations.
	func displayDiningHallCenters() {
		for i in 0...latitudes.count - 1 {
			displayDiningHall(i)
		}
		mapViewer.showAnnotations(diningHallAnnotations, animated: true)
	}
	
	// Finds all of the distances between the location of the user and each of the dining halls,
	// then assigns this information to the subtitles of the dining halls.
	func findDistances(myLocation:CLLocation) {
		var myDistances: [Float] = [Float]()
		for i in 0...diningHallAnnotations.count - 1 {
			let dist = distance(myLocation, second: diningHallAnnotations[i].coordinate)
			myDistances += [dist]
			diningHallAnnotations[i].subtitle = "\(dist) meters away"
		}
		findThreeSmallest(myDistances)
	}
	
	// -----------------------Configure 3-Smallest Labels-----------------------------
	
	// Finds the three smallest distances from a float array and then changes the information shown to the user.
	func findThreeSmallest(myDistances: [Float]) {
		var num1:Float = 10000.0
		var i1 = -1
		var num2:Float = 10000.0
		var i2 = -1
		var num3:Float = 10000.0
		var i3 = -1
		
		for i in 0...myDistances.count - 1 {
			if (myDistances[i] < num1) {
				i1 = i;
				num1 = myDistances[i]
			}
		}
		for i in 0...myDistances.count - 1 {
			if (myDistances[i] < num2 && myDistances[i] > num1) {
				i2 = i;
				num2 = myDistances[i]
			}
		}
		for i in 0...myDistances.count - 1 {
			if (myDistances[i] < num3 && myDistances[i] > num2) {
				i3 = i;
				num3 = myDistances[i]
			}
		}
		closest1.text = "1. \(names[i1]), \(num1) meters"
		closest2.text = "2. \(names[i2]), \(num2) meters"
		closest3.text = "3. \(names[i3]), \(num3) meters"
		diningHallNames[0] = names[i1]
		diningHallNames[1] = names[i2]
		diningHallNames[2] = names[i3]
		diningHallNamesShort[0] = diningHalls[i1]
		diningHallNamesShort[1] = diningHalls[i2]
		diningHallNamesShort[2] = diningHalls[i3]
	}
	
	
	// Creates a dining hall from a given index point for the names, longitudes, and latitudes array.
	func displayDiningHall(index:Int) {
		if (index < names.count) {
			let name = names[index]
			let longitude = longitudes[index]
			let latitude = latitudes[index]
			let local = CLLocationCoordinate2DMake(latitude, longitude)
			let pinCoordinate = CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
			let annotation = MKPointAnnotation()
			annotation.coordinate = pinCoordinate
			annotation.title = name
			diningHallAnnotations += [annotation]
			mapViewer.addAnnotation(annotation)
		}
	}
	
	// Displays the user's location.
	func displayLocation(location:CLLocation) {
		mapViewer.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
		
		let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		let annotation = MKPointAnnotation()
		annotation.coordinate = locationPinCoord
		annotation.title = "You are Here"
		findDistances(location)
		mapViewer.addAnnotation(annotation)
		let all = diningHallAnnotations + [annotation];
		mapViewer.showAnnotations(all, animated: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

