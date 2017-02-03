//
//  NearbyViewController.swift
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

class NearbyViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
	var coreLocationManager = CLLocationManager()
	var chosenDiningHall = ""
	var chosenShort = ""
	var first = true
	var latitudes:[Double] = [42.294580,42.291953,42.292747,42.291104,42.295818]
	var longitudes:[Double] = [-71.308941,-71.300282,-71.308737,-71.302814,-71.307396]
	
	var pinColors:[UIColor] = Array(repeating: UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), count: 5)
	var pinTitles:[String] = Array(repeating: "", count: 5)
	var subtitles:[String] = Array(repeating: "", count: 5)
	
	// Leaky beaker: 42.293866, -71.302857,
	let diningHalls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy"]
	var names = ["Bae Pao Lu Chow", "Bates", "Tower", "Stone Davis", "Pomeroy"]
	var menus = [String:[String]]()
	let diningHallDictionaryKey = "diningHallDictionaryKey"
	let todaysDateKey = "todaysDateKey"
	
	var diningHallAnnotations:[MKPointAnnotation] = [MKPointAnnotation]();
	var currentLocation:CLLocation = CLLocation()
	
	var hallPicker:UIPickerView = UIPickerView()
	let hallToolBar:UIToolbar = UIToolbar()
	let hallInputView:UIInputView = UIInputView()
	
	let storedData:UserDefaults = UserDefaults()
	var diningHallNames:[String] = ["", "", ""]
	var diningHallNamesShort:[String] = ["", "", ""]
	var items:[String] = []
	var barButtonDone:UIBarButtonItem {
		return UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(madeSelection))
	}
	var barButtonSpace:UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
	}
	var barButtonCancel:UIBarButtonItem {
		return UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelSelection))
	}
	
	var tableview:UITableView = UITableView()
	var meters = true
	
	var headerTitle = "Choose a dining hall by clicking the button above."
	
	var hours = DiningHours()
	
	@IBOutlet weak var mapViewer: MKMapView!
	@IBOutlet weak var pickerButton: UIButton!
	
	@IBAction func showSelector() {
		hallInputView.isHidden = false;
	}
	
	
	var tableScrollsToNextMeal = false
	
	let tableScrollsToNextMealKey = "tableScrollsToNextMealKey"
	
	var myUnits:String = ""
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		
		tableview.register(MyCell.self, forCellReuseIdentifier: "cellId")
		
		// Assigns the class Header to the type of header cell that we use
		tableview.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
		
		tableview.delegate = self
		tableview.dataSource = self
		
		tableview.sizeToFit()
		
		// ty to this tutorial for the following code for auto-height for cells: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
		tableview.estimatedRowHeight = 140
		
		self.view.addSubview(tableview)
		
		
		hallPicker.isHidden = false
		hallPicker.dataSource = self
		hallPicker.delegate = self
		hallPicker.backgroundColor = UIColor.white
		hallPicker.showsSelectionIndicator = true
		
		hallToolBar.barStyle = UIBarStyle.default
		hallToolBar.isTranslucent = true
		
		hallToolBar.setItems([barButtonCancel, barButtonSpace, barButtonDone], animated: false)
		hallPicker.tag = 40
		hallInputView.addSubview(hallToolBar)
		hallInputView.addSubview(hallPicker)
		hallInputView.isHidden = true
		hallInputView.backgroundColor = UIColor.white
		self.view.addSubview(hallInputView)
		
		mapViewer.delegate = self
		
		coreLocationManager.delegate = self
		
		let authorizationCode = CLLocationManager.authorizationStatus()
		
		if authorizationCode == CLAuthorizationStatus.notDetermined && coreLocationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
			print("Authorization not determined...")
			if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil {
				coreLocationManager.requestWhenInUseAuthorization()
			} else {
				print("No description provided")
			}
			storedData.set("m", forKey: "Preferred Units")
		} else {
			print("Getting initial location...")
			first = false
			self.getInitialLocation()
			
			displayDiningHallCenters()
		}
		
		myUnits = checkUnits()
		
		
		if self.tabBarController != nil {
			if (self.tabBarController?.viewControllers?.count)! > 1 {
				let nc = self.tabBarController?.viewControllers?[1] as! UINavigationController
				let mvc = nc.topViewController as! MenuViewController
				mvc.loadData()
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if tableScrollsToNextMeal {
			print("Table Scrolls To Next Meal.")
			
			
			
			//			tableView.scro
		} else {
			print("Table does not scroll to Next Meal.")
		}
	}
	
	func checkNetworkStatus() -> Bool {
		let reachability: Reachability = Reachability.forInternetConnection()
		let networkStatus = reachability.currentReachabilityStatus().rawValue;
		var isAvailable  = false;
		
		switch networkStatus {
		case (NotReachable.rawValue):
			isAvailable = false;
			break;
		case (ReachableViaWiFi.rawValue):
			isAvailable = true;
			break;
		case (ReachableViaWWAN.rawValue):
			isAvailable = true;
			break;
		default:
			isAvailable = false;
			break;
		}
		return isAvailable;
	}
	
	override func viewWillAppear(_ animated: Bool) {
		print("FirstViewController will appear.")
		
		if !checkNetworkStatus() {
			print("No network.")
			let alert = UIAlertController(title: "Cannot Access Network", message: "Internet access is required to use this application. Please turn on wifi.", preferredStyle: .alert)
			let a = UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
				UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
			})
			
			let b = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			alert.addAction(a)
			alert.addAction(b)
			
			self.navigationController?.present(alert, animated: true, completion: nil)
		} else {
			
			
			
			let height = self.view.frame.origin.y + self.view.frame.size.height
			hallPicker.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 400)
			hallInputView.frame = CGRect(x: 0, y: self.view.frame.origin.y + self.view.frame.size.height - 440, width: self.view.frame.size.width, height: 440)
			hallToolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
			//		let hLimit = showDiningHallName.frame.origin.y + 30;
			
			let tabBarH = (tabBarController?.tabBar.frame.size.height)!
			print("\nTab Bar Height: \(tabBarH)\n")
			
			print("\nHeight: \(height)\n")
			
			let tableX = 0.0
			let tableY = pickerButton.frame.origin.y + pickerButton.frame.size.height*2;
			let tableW = self.view.frame.size.width
			let tableH = (height - tableY - tabBarH);
			
			print("\nTable Height: \(tableH)\n")
			tableview.frame = CGRect(x: CGFloat(tableX), y: tableY, width: tableW, height: tableH)
			
			
			if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
				mapViewer.showsUserLocation = true
			}
			let oldUnits:String = myUnits
			myUnits = checkUnits()
			if (!myUnits.contains(oldUnits)) {
				meters = false
				findDistances(mapViewer.userLocation.location!)
			}
			
			tableScrollsToNextMeal = storedData.bool(forKey: tableScrollsToNextMealKey)
		}
		
		
//		print(mapViewer.frame)
	}
	
	func checkUnits() -> String {
		if storedData.object(forKey: "Preferred Units") != nil {
			return storedData.object(forKey: "Preferred Units") as! String
		} else {
			return "ft"
		}
	}
	
	// ====================================================================
	// ------------------------DELEGATE METHODS----------------------------
	// ====================================================================

	
	// ------------UITableView Delegate and Datasource Methods-------------
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
		if (self.items.count > 0) {
			myCell.nameLabel.text = self.items[indexPath.row]
			let meals = ["Breakfast", "Lunch", "Dinner"]
			//		print(myCell.nameLabel.text)
			if meals.contains(items[indexPath.row]) {
				myCell.backgroundView?.backgroundColor = UIColor.groupTableViewBackground
				myCell.backgroundColor = UIColor.groupTableViewBackground
				myCell.separatorInset = myCell.regularSepInsets
				myCell.nameLabel.font = myCell.boldFont
			} else {
				myCell.backgroundColor = UIColor.white
				myCell.nameLabel.font = myCell.regularFont
			}
			
			if indexPath.row + 1 < items.count {
				if meals.contains(items[indexPath.row + 1]) {
					myCell.separatorInset = myCell.regularSepInsets
				}
			}
		} else {
			myCell.nameLabel.text = ""
		}
		return myCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
		myHeader.contentView.backgroundColor = UIColor.groupTableViewBackground
		myHeader.nameLabel.text = self.headerTitle
		myHeader.alpha = 1
//		print("Header being used!!!!!")
		return myHeader
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
	}
	
	
	func adjustHeightOfTableview() {
//		var height:CGFloat = 0;
//		
//		for i in 0...items.count - 1 {
//			if (tableview.cellForRow(at: IndexPath(row: i, section: 0)) != nil) {
//				let cell:MyCell = tableview.cellForRow(at: IndexPath(row: i, section: 0)) as! MyCell
//				height = height + cell.frame.height;
//			}
//		}
//		
//		if tableview.contentSize.height != height {
//			tableview.contentSize = CGSize(width: tableview.contentSize.width, height: height)
//		}
	}
	
	
	// ----------UIPickerView Datasource and Delegate Functions-----------
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 3
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return diningHallNames[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		chosenDiningHall = diningHallNames[row]
		chosenShort = diningHallNamesShort[row]
		print("Selected: ", diningHallNames[row])
	}
	
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return self.view.frame.size.width * 0.8
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
	
	// -----------------CLLocationManager Delegate Functions-----------------
	// All of these functions react to a certain event.
	
	// Fires when an error happens.
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed with an error")
	}
	
	// Fires when the location updates.
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Updated location")
		let last = locations.count - 1
		displayLocation(locations[last])
		displayDiningHallCenters()
	}
	
	// Fires when the authorization status updates.
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status != CLAuthorizationStatus.notDetermined || status != CLAuthorizationStatus.denied || status != CLAuthorizationStatus.restricted {
			if (first) {
				first = false
				displayDiningHallCenters()
				getInitialLocation()
			} else {
				print("Well this is happening")
				getLocation()
				
			}
		}
	}
	
	// -----------------MKMapViewDelegate Delegate Functions-----------------
	
	func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
		print("Will start loading the map!")
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		
		var mkpin = mapView.dequeueReusableAnnotationView(withIdentifier: "pinId") as? MKPinAnnotationView
		if mkpin == nil {
			mkpin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinId")
			mkpin?.canShowCallout = true
		} else {
			mkpin?.annotation = annotation
		}
		if annotation.title != nil {
			for i in 0..<diningHallAnnotations.count {
				if (annotation.title??.contains((diningHallAnnotations[i].title)!))! {
					if #available(iOS 9, *) {
						mkpin?.pinTintColor = pinColors[i]
						break
					} else {
						mkpin?.pinColor = MKPinAnnotationColor.red
						break
					}
				}
			}
		}
		return mkpin
	}
	
	
	// ======================================================================
	// ------------------------------HELPERS---------------------------------
	// ======================================================================
	
	// Retitles the header of the tableview
	func retitleHeader() {
		if (tableview.headerView(forSection: 0) != nil) {
			(tableview.headerView(forSection: 0) as! Header).nameLabel.text = self.chosenDiningHall
			headerTitle = self.chosenDiningHall
		}
	}
	
	// Tells the hallInputView to go away
	func madeSelection() {
		hallInputView.isHidden = true

			
		if storedData.string(forKey: todaysDateKey) != nil {
			let storedDateKey:String = storedData.string(forKey: todaysDateKey)!
			
			var today:Date
			today = Date.init()
			
			
			// Create a date formatter
			let MyDateFormatter = DateFormatter()
			MyDateFormatter.locale = Locale(identifier: "en_US_POSIX")
			MyDateFormatter.dateFormat = "MMdd"
			// Now make a date that represents today - we use this to retrieve the menu for the day
			let todayString:String = MyDateFormatter.string(from: today)
			print(storedDateKey, "vs", todayString)
			
			if (storedDateKey == todayString) {
				menus = storedData.dictionary(forKey: diningHallDictionaryKey) as! [String:[String]]
				newCellsInsertion()
				retitleHeader()
				scrollToNextMeal()
			}
		}
	}
	
	// Tell hallInputView to go away because you canceled
	func cancelSelection() {
		hallInputView.isHidden = true
	}
	
	func scrollToNextMeal() {
		if tableScrollsToNextMeal {
			let nextMeal = hours.nextMeal(chosenShort)
			
			print("\nscrollToNextMeal()")
			print("Next meal: \(nextMeal)")
			print("Chosen short: \(chosenShort)")
			let array:[String] = menus[chosenShort]!
			let ind = array.index(of: nextMeal)
			if ind != nil {
				print("Index: \(ind)")
				print("\n")
				let ip = IndexPath(row: ind!, section: 0)
//				tableview.scrollToRow(at: ip, at: .middle, animated: true)
				tableview.scrollToRow(at: ip, at: .middle, animated: false)
			}
		}
	}
	
	// ------------------Functions for Showing New Data-------------------
	
	func newCellsInsertion() {
		if menus[chosenShort] != nil {
			performInsertion()
		}
	}
	
	func performInsertion() {
		var normalArray:[String] = menus[chosenShort]!
		if (normalArray.count >= 1) {
			let originalSize:Int = items.count
			let newSize:Int = normalArray.count
			
//			print("Old Size, New Size: ", originalSize, ", ", newSize, separator: "")
			var indexPaths = [IndexPath]()
			var originalPaths = [IndexPath]()
			var bottomHalfIndexPaths = [IndexPath]()
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
						indexPaths.append(IndexPath(row: i, section: 0))
					} else {
						originalPaths.append(IndexPath(row: i, section: 0))
					}
				}
				
				if (isAbsoluteDiffGreaterThanOne) {
					for _ in 0...indexPaths.count / 2 - 1 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
				}
				
				tableview.beginUpdates()
				tableview.reloadRows(at: originalPaths, with: .fade)
				if (isAbsoluteDiffGreaterThanOne) {
					tableview.insertRows(at: indexPaths, with: .right)
					tableview.insertRows(at: bottomHalfIndexPaths, with: .left)
				} else if (newSize - originalSize == 1) {
					tableview.insertRows(at: indexPaths, with: .right)
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
						indexPaths.append(IndexPath(row: i, section: 0))
					} else {
						originalPaths.append(IndexPath(row: i, section: 0))
					}
				}
				
				if indexPaths.count > 2 {
					for _ in 0...indexPaths.count / 2 - 1 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
					
					tableview.beginUpdates()
					tableview.reloadRows(at: originalPaths, with: .fade)
					tableview.deleteRows(at: indexPaths, with: .right)
					tableview.deleteRows(at: bottomHalfIndexPaths, with: .left)
					tableview.endUpdates()
					adjustHeightOfTableview()
				} else {
					tableview.beginUpdates()
					tableview.reloadRows(at: originalPaths, with: .fade)
					tableview.deleteRows(at: indexPaths, with: .right)
					tableview.endUpdates()
					adjustHeightOfTableview()
				}
			}
		}
	}

	
	// Helper function that calculates distance over a sphere.
	func distance(_ first:CLLocation, second:CLLocationCoordinate2D) -> Float {
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
		var d:Float = 6371043.0 * c;
		switch myUnits {
			case "ft":
			d *= 3.28084
			case "km":
			d *= 0.001
			case "yd":
			d *= 0.333 * 3.28084
			case "mi":
			d *= 3.28084 * (1.0 / 5280.0)
		default:
			break
		}
		
		return d
	}
	
	// Helper function that converts degrees (latitude, longitude) to radians
	func radians(_ degrees:Float)->Float {
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
		if #available(iOS 9, *) {
			coreLocationManager.requestLocation()
		}
//		coreLocationManager.startUpdatingLocation()
		coreLocationManager.startMonitoringSignificantLocationChanges()
	}
	
	// Displays the user's location.
	func displayLocation(_ location:CLLocation) {
		if !currentLocation.isEqual(location) {
			mapViewer.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
			currentLocation = location
			print("\nLocation: (", location.coordinate.latitude, ", ", location.coordinate.longitude, ")")
			
			findDistances(location)
			mapViewer.showAnnotations(diningHallAnnotations, animated: true)
//			coreLocationManager.stopUpdatingLocation()
		}
		
	}
	
	// -------------------------Get Web Data----------------------------
	
	// Downloads the data from the Wellesley Fresh site in an attempt to get the data.
	func getWellesleyFreshData() {
		let url = URL(string: "http://www.wellesleyfresh.com/today-s-menu.html")
		let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
			if error == nil {
				print(String(data: data!, encoding: .utf8)!)
			}
		}
		task.resume()
	}
	
	// --------------------Configure dining hall annotations------------------------
	
	// Creates a dining hall from a given index point for the names, longitudes, and latitudes array.
	func displayDiningHall(_ index:Int) {
		if (index < names.count) {
			
			let name = names[index]
			let longitude = longitudes[index]
			let latitude = latitudes[index]
			let local = CLLocationCoordinate2DMake(latitude, longitude)
			let pinCoordinate = CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
			let annotation = MKPointAnnotation()
			annotation.coordinate = pinCoordinate
			annotation.title = name
			annotation.subtitle = subtitles[index]
			diningHallAnnotations += [annotation]
			mapViewer.addAnnotation(annotation)
		}
	}
	
	// Create all of the dining hall annotations.
	func displayDiningHallCenters() {
		mapViewer.removeAnnotations(diningHallAnnotations)
		diningHallAnnotations = [MKPointAnnotation]()
		for i in 0..<latitudes.count {
			displayDiningHall(i)
		}
		mapViewer.showAnnotations(diningHallAnnotations, animated: true)
	}
	
	// Finds all of the distances between the location of the user and each of the dining halls,
	// then assigns this information to the subtitles of the dining halls.
	func findDistances(_ myLocation:CLLocation) {
//		print("Creating Subtitles for Dining Hall Anontations")
		var myDistances: [Float] = [Float]()
		let numformat = NumberFormatter()
		numformat.numberStyle = NumberFormatter.Style.decimal
//		print("Dining Hall Anontations Count: ", diningHallAnnotations.count)
		for i in 0..<diningHallAnnotations.count {
			let dist = distance(myLocation, second: diningHallAnnotations[i].coordinate)
			myDistances += [dist]
			//let myUnits = meters ? "m" : "ft"
			subtitles[i] = "\(numformat.string(from: NSNumber(value: dist))!) \(myUnits) away"
			diningHallAnnotations[i].subtitle = subtitles[i] //"\(dist) \(myUnits) away"
		}
		findThreeSmallest(myDistances)
	}
	
	
	
	// -----------------------Configure 3-Smallest Labels-----------------------------
	
	// Finds the three smallest distances from a float array and then changes the information shown to the user.
	func findThreeSmallest(_ myDistances: [Float]) {
		var nums:[Float] = Array(repeating: 1000000000000000.0, count: 5)
		var indices:[Int] = Array(repeating: -1, count: 5)
		let colors:[UIColor] = [UIColor.red, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple]
		for i in 0..<nums.count {
			for j in 0..<myDistances.count {
				if i > 0 {
					if myDistances[j] < nums[i] && myDistances[j] > nums[i - 1] {
						nums[i] = myDistances[j]
						indices[i] = j
					}
				} else {
					if myDistances[j] < nums[i] {
						nums[i] = myDistances[j]
						indices[i] = j
					}
				}
			}
			pinColors[indices[i]] = colors[i]
		}
		for i in 0..<3 {
			if indices[i] >= 0 {
				diningHallNames[i] = names[indices[i]]
				diningHallNamesShort[i] = diningHalls[indices[i]]
				if i == 0 {
					chosenShort = diningHallNamesShort[i]
					chosenDiningHall = diningHallNames[i]
				}
			}
		}
		hallPicker.reloadAllComponents()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

