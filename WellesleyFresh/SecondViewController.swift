//
//  SecondViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 9/8/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
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
	let storedData:NSUserDefaults = NSUserDefaults()
	let diningHallDictionaryKey = "diningHallDictionaryKey"
	let todaysDateKey = "todaysDateKey"
	var barButtonDone:UIBarButtonItem {
		return UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SecondViewController.madeSelection))
	}
	var barButtonSpace:UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
	}
	var barButtonCancel:UIBarButtonItem {
		return UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SecondViewController.madeSelection))
	}
	var hallInputView:UIInputView = UIInputView()
	
	var regexHelper:WellesleyFreshRegex = WellesleyFreshRegex()
	
	let cellHeight:Int = 60
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Get an NSDate object
		var today:NSDate
		today = NSDate.init()
		
		
		// Create a date formatter
		let MyDateFormatter = NSDateFormatter()
		MyDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		MyDateFormatter.dateFormat = "MMdd"
		// Now make a date that represents today - we use this to retrieve the menu for the day
		todayString = MyDateFormatter.stringFromDate(today)
		
		print(todayString)
		//		todayString = "1004"
		
		if storedData.stringForKey(todaysDateKey) != nil {
			if (storedData.stringForKey(todaysDateKey) == todayString) {
				print("Already got data today.")
				diningHallArrays = storedData.dictionaryForKey(diningHallDictionaryKey) as! [String:[String]]
			} else {
				print("Needed to get data for today.")
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
		tableView.registerClass(MyCell.self, forCellReuseIdentifier: "cellId")
		
		// Assigns the class Header to the type of header cell that we use
		tableView.registerClass(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
		
		//		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .Plain, target: self, action: "newCellsInsertion")
		//		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .Plain, target: self, action: "insertBatch")
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Choose Hall", style: .Plain, target: self, action: #selector(SecondViewController.showPickerView))
		
		tableView.sizeToFit()
		
		// ty to this tutorial for the following code for auto-height for cells: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
		//		tableView.rowHeight =
		tableView.estimatedRowHeight = 140
		
		refreshControl = UIRefreshControl()
		refreshControl!.attributedTitle = NSAttributedString(string: "Pull for a Random Dining Hall")
		refreshControl!.addTarget(self, action: #selector(SecondViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshControl!)
		
		// Adding picker view/controlling what it looks like
		
		hallPicker.hidden = false
		hallPicker.dataSource = self
		hallPicker.delegate = self
		hallPicker.backgroundColor = UIColor.whiteColor()
		hallPicker.showsSelectionIndicator = true
		
		hallToolBar.barStyle = UIBarStyle.Default
		hallToolBar.translucent = true
		
		//		barButtonDone.tintColor = UIColor.blackColor()
		hallToolBar.setItems([barButtonCancel, barButtonSpace, barButtonDone], animated: false)
		//		hallToolBar.userInteractionEnabled = true
		hallPicker.tag = 40
		//		hallPicker.addSubview(hallToolBar)
		hallInputView.addSubview(hallToolBar)
		hallInputView.addSubview(hallPicker)
		hallInputView.hidden = false
		hallInputView.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(hallInputView)
	}
	
	override func viewWillAppear(animated: Bool) {
		let height = self.tableView.frame.origin.y + self.tableView.frame.size.height
		print("superview:", self.tableView.superview)
		print("Height:", self.tableView.superview!.frame.size.height - 400.0)
		hallPicker.frame = CGRectMake(0, 40, tableView.contentSize.width, 400)
		hallInputView.frame = CGRectMake(0, height - (height * 0.6), tableView.contentSize.width, height * 0.6)
		hallToolBar.frame = CGRectMake(0, 0, tableView.contentSize.width, 40)
		self.view.bringSubviewToFront(hallInputView)
	}
	
	func madeSelection() {
		//		self.view.viewWithTag(40)!.hidden = true
		self.hallInputView.hidden = true;
		print("Made selection: \(diningHall).")
		choose()
		//		hallPicker.removeFromSuperview()
		//		hallToolBar.superview?.hidden = true
	}
	
	func showPickerView() {
		previousDiningHall = diningHall;
		self.hallInputView.hidden = false
		self.view.bringSubviewToFront(hallInputView)
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return diningHalls.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return diningHallFull[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		diningHall = diningHalls[row]
		diningHallName = diningHallFull[row]
		print("Selected: ", diningHallName)
	}
	
	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return tableView.contentSize.width * 0.8
	}
	
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
	
	func preload() {
		for i in 0...diningHalls.count - 1 {
			load(diningHalls[i])
		}
	}
	
	func retitleHeader() {
		if (tableView.headerViewForSection(0) != nil) {
			for i in 0...diningHalls.count - 1 {
				if (diningHalls[i] == self.diningHall) {
					(tableView.headerViewForSection(0) as! Header).nameLabel.text = self.diningHallFull[i]
				}
			}
		}
	}
	
	func headerTitle() -> String {
		if (tableView.headerViewForSection(0) != nil) {
			return (tableView.headerViewForSection(0) as! Header).nameLabel.text as String!
		}
		return ""
	}
	
	func choose() {
		if !loadingHall {
			if previousDiningHall != diningHall {
				retitleHeader()
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
		}
	}
	
	func refresh() {
		if !loadingHall {
			
			let chosenDiningHall = Int(arc4random_uniform(UInt32(diningHalls.count)))
			retitleHeader()
//			if (normalArray.count > 0) {
//				let keyExists = diningHallArrays[diningHall] != nil
//				if (!keyExists) {
//					diningHallArrays[diningHall] = normalArray
//				}
//			}
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
					self.refreshControl?.endRefreshing()
					normalArray = diningHallArrays[diningHall]!
				}
			} else {
				load(diningHall)
			}
		} else {
			self.refreshControl?.endRefreshing()
		}
	}
	
	func insertBatch() {
		var indexPaths = [NSIndexPath]()
		for i in items.count...items.count + 5 {
			items.append("Item \(i + 1)")
			indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
		}
		
		var bottomHalfIndexPaths = [NSIndexPath]()
		for _ in 0...indexPaths.count / 2 - 1 {
			bottomHalfIndexPaths.append(indexPaths.removeLast())
		}
		tableView.beginUpdates()
		tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
		tableView.insertRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
		tableView.endUpdates()
	}
	
	func newCellsInsertion() {
		if (normalArray.count >= 1) {
			let originalSize:Int = items.count
			let newSize:Int = normalArray.count
			
			print(originalSize, ", ", newSize, separator: "")
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
				
				tableView.beginUpdates()
				tableView.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
				if (isAbsoluteDiffGreaterThanOne) {
					tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableView.insertRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
				} else if (newSize - originalSize == 1) {
					tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
				}
				tableView.endUpdates()
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
					
					tableView.beginUpdates()
					tableView.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
					tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableView.deleteRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
					tableView.endUpdates()
				} else {
					tableView.beginUpdates()
					tableView.reloadRowsAtIndexPaths(originalPaths, withRowAnimation: .Fade)
					tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
					tableView.endUpdates()
				}
			}
			
			if self.refreshControl != nil {
				self.refreshControl!.endRefreshing()
			}
		} else {
			if self.refreshControl != nil {
				self.refreshControl!.endRefreshing()
			}
		}
	}
	
	func batchInsertion(newStrings: [String]) {
		let originalSize:Int = items.count
		print(originalSize)
		let newSize:Int = newStrings.count
		print(originalSize, ", ", newSize, separator: "")
		if (newSize > originalSize) {
			var indexPaths = [NSIndexPath]()
			for i in 0...newStrings.count - 1 {
				if (i < newStrings.count) {
					if (i < items.count) {
						items[i] = newStrings[i]
					} else {
						items.append(newStrings[i])
					}
					if (i >= originalSize) {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
				}
			}
			
			var bottomHalfIndexPaths = [NSIndexPath]()
			for _ in 0...indexPaths.count / 2 - 1 {
				bottomHalfIndexPaths.append(indexPaths.removeLast())
			}
			
			tableView.beginUpdates()
			tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
			tableView.insertRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
			tableView.endUpdates()
		} else if (newSize < originalSize) {
			var indexPaths = [NSIndexPath]()
			for i in 0...originalSize - 1 {
				if (i < newSize) {
					if (i < items.count) {
						items[i] = newStrings[i]
					} else {
						items.removeLast()
						//						items.append(newStrings[i])
					}
					if (i >= newSize) {
						indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
					}
				}
			}
			
			if ((originalSize - newSize) >= 2) {
				var bottomHalfIndexPaths = [NSIndexPath]()
				for _ in 0...indexPaths.count / 2 - 1 {
					bottomHalfIndexPaths.append(indexPaths.removeLast())
				}
				
				tableView.beginUpdates()
				tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
				tableView.deleteRowsAtIndexPaths(bottomHalfIndexPaths, withRowAnimation: .Left)
				tableView.endUpdates()
			} else {
				tableView.beginUpdates()
				tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Right)
				tableView.endUpdates()
			}
		}
	}
	
	func insert() {
		items.append("Item \(items.count + 1)")
		let insertionIndexPath = NSIndexPath(forRow: items.count - 1, inSection: 0)
		tableView.insertRowsAtIndexPaths([insertionIndexPath], withRowAnimation: .Automatic)
	}
	
	func extractString(inputString:String, regex:NSRegularExpression, regexTemplate:String) -> String {
		return regex.stringByReplacingMatchesInString(inputString, options: [], range: NSRange(location: 0, length: inputString.characters.count), withTemplate: regexTemplate)
	}
	
	// Load the information from a specific dining hall
	func load(hall:String) {
		self.loadingHall = true
		print("loading hall ", hall)
		
		// Get the url for the specific menu
		let url:NSURL! = NSURL(string: "http://www.wellesleyfresh.com/menus/" + hall + "/menu_" + todayString + ".htm")
		
		// Create the task + the completion handler for the url session
		let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
			// Strings are Windows 1252 encoded for some reason
			let mystring:NSString! = NSString(data: data!, encoding: NSWindowsCP1252StringEncoding)
			
			let bodyString:String = self.regexHelper.extractInformationString(mystring as String)
			print("\n\n\n\n\nDigest string:\n|", bodyString, "|\nEnd of string", separator: "")
			self.normalArray = bodyString.componentsSeparatedByString("\n")
			self.diningHallArrays[hall] = self.normalArray
			self.storedData.setObject(self.diningHallArrays, forKey: self.diningHallDictionaryKey)
			self.loadingHall = false;
		}
		// Start the task
		task.resume()
	}
	
	//	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
	//		return CGFloat(cellHeight)
	//	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! MyCell
		myCell.nameLabel.text = items[indexPath.row]
//		myCell.myTableViewController = self
		return myCell
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerId") as! Header
		myHeader.nameLabel.text = self.diningHall
//		myHeader.myTableViewController = self
		return myHeader
	}
	
	func deleteCell(cell: UITableViewCell) {
		if let deletionIndexPath = tableView.indexPathForCell(cell) {
			items.removeAtIndex(deletionIndexPath.item)
			tableView.deleteRowsAtIndexPaths([deletionIndexPath], withRowAnimation: .Automatic)
		}
	}
	override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		adjustHeightOfTableview()
	}
	
	func adjustHeightOfTableview() {
		let height:CGFloat = CGFloat(items.count * cellHeight);
		//		let maxHeight:CGFloat = self.tableView.superview!.frame.size.height - self.tableView.frame.origin.y;
		
		if tableView.contentSize.height != height {
			tableView.contentSize = CGSize(width: tableView.contentSize.width, height: height)
		}
		// if the height of the content is greater than the maxHeight of
		// total space on the screen, limit the height to the size of the
		// superview.
		
		//		if (height > maxHeight) {
		//			height = maxHeight;
		//		}
		//		print("Height: ", height);
		
		// now set the height constraint accordingly
		
	}
}