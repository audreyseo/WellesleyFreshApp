//
//  MenuViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 9/8/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	let diningHalls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy"]
	let diningHallFull:[String] = ["Bao Pao Lu Chow", "Bates", "Tower", "Stone Davis", "Pomeroy"]
	var todayString:String = ""
	var diningHall:String = ""
	var diningHallName:String = ""
	var previousDiningHall:String = ""
	var items = [String]()
	var normalArray = [String]()
	var loadingHall:Bool = false
	var diningHallArrays:[String:[String]] = [:]
	var hallPicker:UIPickerView = UIPickerView()
	let hallToolBar:UIToolbar = UIToolbar()
	let storedData:UserDefaults = UserDefaults()
	let diningHallDictionaryKey:String = "diningHallDictionaryKey"
	let todaysDateKey:String = "todaysDateKey"
	var barButtonDone:UIBarButtonItem {
		return UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.madeSelection))
	}
	var barButtonSpace:UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
	}
	var barButtonCancel:UIBarButtonItem {
		return UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.madeSelection))
	}
	var hallInputView:UIInputView = UIInputView()
	
	var regexHelper:WellesleyFreshRegex = WellesleyFreshRegex()
	
	let cellHeight:Int = 60
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Get an NSDate object
		var today:Date
		today = Date.init()
		
		
		// Create a date formatter
		let MyDateFormatter = DateFormatter()
		MyDateFormatter.locale = Locale(identifier: "en_US_POSIX")
		MyDateFormatter.dateFormat = "MMdd"
		
		// Now make a date that represents today - we use this to retrieve the menu for today
		todayString = MyDateFormatter.string(from: today)
		
		print(todayString)
		
		
		// Use the following two lines for debugging purposes, specifically for debugging the regex parsing
		// and string manipulation.
		todayString = "1003"
		storedData.set("1004", forKey: todaysDateKey)
		
		if storedData.string(forKey: todaysDateKey) != nil {
			if (storedData.string(forKey: todaysDateKey) == todayString) {
				print("Already got data today.")
				diningHallArrays = storedData.dictionary(forKey: diningHallDictionaryKey) as! [String:[String]]
			} else {
				print("Needed to get data for today.")
				storedData.setValue(todayString, forKey: todaysDateKey)
				preload()
				refresh()
			}
		} else {
			storedData.setValue(todayString, forKey: todaysDateKey)
			preload()
			refresh()
		}
		
		
		
		tableView.sectionHeaderHeight = 40
		
		navigationItem.title = "Menu"
		
		// Assigns the class MyCell to the type of cell that we use in the table view
		tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
		
		// Assigns the class Header to the type of header cell that we use
		tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Choose Hall", style: .plain, target: self, action: #selector(MenuViewController.showPickerView))
		
		tableView.sizeToFit()
		
		// ty to this tutorial for the following code for auto-height for cells: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
		tableView.estimatedRowHeight = 140
		
		
		// Adding picker view/controlling what it looks like
		
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
		hallInputView.isHidden = false
		hallInputView.backgroundColor = UIColor.white
		self.navigationController?.view.addSubview(hallInputView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		let height = self.tableView.frame.origin.y + self.tableView.frame.size.height
		//print("superview:", self.tableView.superview?)
		//print("Height:", self.tableView.superview!.frame.size.height - 400.0)
		hallPicker.frame = CGRect(x: 0, y: 40, width: tableView.contentSize.width, height: 400)
		
		hallInputView.frame = CGRect(x: 0, y: height - (height * 0.6), width: tableView.contentSize.width, height: height * 0.6)
		hallToolBar.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: 40)
		//self.view.bringSubview(toFront: hallInputView)
		//self.navigationController?.view.bringSubview(toFront: hallPicker)
		
		let footerView = GroupHeader(reuseIdentifier: "headerId")
		footerView.nameLabel.text = ""
		footerView.isOpaque = true
		
		// Need to delete either one of these but all I wanted is for the background to be normal hallelujah
		self.tableView.backgroundColor = UIColor.groupTableViewBackground
		self.view.backgroundColor = UIColor.groupTableViewBackground
		self.tableView.tableFooterView = footerView
		self.tableView.tableFooterView?.tintColor = UIColor.groupTableViewBackground
		
	}
	
	// --------------------------------------------------------------------
	// ------------------------DELEGATE METHODS----------------------------
	// --------------------------------------------------------------------
	
	// PICKER VIEW DELEGATE FUNCTIONS
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return diningHalls.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return diningHallFull[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		diningHall = diningHalls[row]
		diningHallName = diningHallFull[row]
		print("Selected: ", diningHallName)
	}
	
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return tableView.contentSize.width * 0.8
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
	
	// TABLEVIEW DELEGATE FUNCTIONS
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return self.diningHall
		} else {
			return ""
		}
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return items.count
		} else {
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
		myCell.nameLabel.text = items[indexPath.row]
		//		myCell.myTableViewController = self
		return myCell
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
		myHeader.contentView.backgroundColor = UIColor.groupTableViewBackground
		if section == 0 {
			
			myHeader.nameLabel.text = self.diningHall
			//		myHeader.myTableViewController = self
		}
		return myHeader
	}
	
	func deleteCell(_ cell: UITableViewCell) {
		if let deletionIndexPath = tableView.indexPath(for: cell) {
			items.remove(at: deletionIndexPath.item)
			tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
		}
	}
	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		adjustHeightOfTableview()
	}
	
	// TABLE VIEW DELEGATE HELPERS
	
	func adjustHeightOfTableview() {
		let height:CGFloat = CGFloat(items.count * cellHeight);
		
		if tableView.contentSize.height != height {
			tableView.contentSize = CGSize(width: tableView.contentSize.width, height: height)
		}
	}
	
	// -------------------------------------------------------------
	// --------------------------HELPERS----------------------------
	// -------------------------------------------------------------
	
	func madeSelection() {
		self.hallInputView.isHidden = true;
		print("Made selection: \(diningHall).")
		choose()
	}
	
	func showPickerView() {
		previousDiningHall = diningHall;
		self.hallInputView.isHidden = false
		self.view.bringSubview(toFront: hallInputView)
	}
	
	
	
	func preload() {
		for i in 0...diningHalls.count - 1 {
			load(diningHalls[i])
		}
	}

	
	func retitleHeader() {
		if (tableView.headerView(forSection: 0) != nil) {
			(tableView.headerView(forSection: 0) as! Header).nameLabel.text = self.diningHallName
			print("Tried to assign ", diningHallName, " to the header view.")
		}
	}
	
	func headerTitle() -> String {
		if (tableView.headerView(forSection: 0) != nil) {
			return (tableView.headerView(forSection: 0) as! Header).nameLabel.text as String!
		}
		return ""
	}
	
	func choose() {
		//if !loadingHall {
		print("Hey there!!!!!!!!")
		retitleHeader()
		if previousDiningHall != diningHall {
			
			if (diningHallArrays[diningHall] != nil) {
				normalArray = diningHallArrays[diningHall]!
			}
			newCellsInsertion()
		} else if headerTitle() != "" {
			if headerTitle() != diningHallName {
				retitleHeader()
				if (diningHallArrays[diningHall] != nil) {
					normalArray = diningHallArrays[diningHall]!
				}
				newCellsInsertion()
			}
		} else {
			if (diningHallArrays[diningHall] != nil) {
				normalArray = diningHallArrays[diningHall]!
			}
			newCellsInsertion()
		}
		//}
	}
	
	func refresh() {
		if !loadingHall {
			
			let chosenDiningHall = Int(arc4random_uniform(UInt32(diningHalls.count)))
			retitleHeader()
			if (diningHallArrays[diningHall] != nil) {
				normalArray = diningHallArrays[diningHall]!
			}
			newCellsInsertion()
			if (previousDiningHall != diningHall) {
				diningHall = diningHalls[chosenDiningHall]
			}
			
			if diningHallArrays.count > 0 {
				let keyExists = diningHallArrays[diningHall] != nil
				if (!keyExists) {
					load(diningHall)
				} else {
					normalArray = diningHallArrays[diningHall]!
				}
			} else {
				load(diningHall)
			}
		}
	}
	
	
	func newCellsInsertion() {
		if (normalArray.count >= 1) {
			let originalSize:Int = items.count
			let newSize:Int = normalArray.count
			
			print(originalSize, ", ", newSize, separator: "")
			var indexPaths = [IndexPath]()
			var originalPaths = [IndexPath]()
			var bottomHalfIndexPaths = [IndexPath]()
			if (newSize >= originalSize) {
				let isAbsoluteDiffGreaterThanOne:Bool = newSize - originalSize > 1
				for i in 0..<normalArray.count {
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
					for _ in 0..<indexPaths.count / 2 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
				}
				
				tableView.beginUpdates()
				tableView.reloadRows(at: originalPaths, with: .fade)
				if (isAbsoluteDiffGreaterThanOne) {
					tableView.insertRows(at: indexPaths, with: .right)
					tableView.insertRows(at: bottomHalfIndexPaths, with: .left)
				} else if (newSize - originalSize == 1) {
					tableView.insertRows(at: indexPaths, with: .right)
				}
				tableView.endUpdates()
			} else if (newSize < originalSize) {
				for i in 0..<originalSize {
					
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
					for _ in 0..<indexPaths.count / 2 {
						bottomHalfIndexPaths.append(indexPaths.removeLast())
					}
					
					tableView.beginUpdates()
					tableView.reloadRows(at: originalPaths, with: .fade)
					tableView.deleteRows(at: indexPaths, with: .right)
					tableView.deleteRows(at: bottomHalfIndexPaths, with: .left)
					tableView.endUpdates()
				} else {
					tableView.beginUpdates()
					tableView.reloadRows(at: originalPaths, with: .fade)
					tableView.deleteRows(at: indexPaths, with: .right)
					tableView.endUpdates()
				}
			}
		}
	}
	
	func trimNormalArray() {
		for i in 0..<self.normalArray.count {
			self.normalArray[i] = self.normalArray[i].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		}
		
		var indexer = 0
		for _ in 0..<self.normalArray.count {
			
			if self.normalArray[indexer] == "" {
				print("|\(self.normalArray[indexer])|")
				self.normalArray.remove(at: indexer)
				indexer -= 1
			}
			indexer += 1
			
			if indexer == self.normalArray.count {
				break
			}
		}
	}
	
	func saveDiningHallArrays(_ hall: String) {
		self.storedData.set(self.diningHallArrays, forKey: self.diningHallDictionaryKey)
		for i in 0...(self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]!.count - 1 {
			print("The new string: ", (self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]![i], separator: "")
		}
	}
	
	func getDiningHallUrlRequest(_ hall: String) -> URLRequest {
		let urlString = "http://www.wellesleyfresh.com/menus/" + hall + "/menu_" + todayString + ".htm"
		return URLRequest(url: URL(string: urlString)!)
	}

	
	// Load the information from a specific dining hall
	func load(_ hall:String) {
		self.loadingHall = true
		print("loading hall ", hall)
		
		// Get the url for the specific menu
//		let urlString = "http://www.wellesleyfresh.com/menus/" + hall + "/menu_" + todayString + ".htm"
//		let url = URLRequest(url: URL(string: urlString)!)
		let request = getDiningHallUrlRequest(hall)
		
		// Create the task + the completion handler for the url session
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			// Strings are Windows 1252 encoded for some reason
			let mystring:String! = String(data: data!, encoding: .windowsCP1252)
//			print("My string: \n\(mystring)")
			
			let bodyString:String = self.regexHelper.extractInformationString(mystring as String)
//			print("\n\n\n\n\nDigest string:\n|", bodyString, "|\nEnd of string", separator: "")
			
			self.normalArray = bodyString.components(separatedBy: "\n")
			self.trimNormalArray()
			
			self.diningHallArrays[hall] = self.normalArray
			self.saveDiningHallArrays(hall)
			
			self.loadingHall = false;
			
		}.resume()
	}
}
