//
//  CompareVC.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 6/2/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//


import UIKit

class CompareViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	let diningHalls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy"]
	let diningHallFull:[String] = ["Bae Pao Lu Chow", "Bates", "Tower", "Stone Davis", "Pomeroy"]
	let mealNames = ["Breakfast", "Lunch", "Dinner"]
	var todayString:String = ""
	var diningHall:String = ""
	var diningHallName:String = ""
	var previousDiningHall:String = ""
	var items = [String]()
	var mealItemCounts = [Int]()
	var normalArray = [String]()
	
	var loadingHall:Bool = false
	var tableScrollsToNextMeal = false
	
	let tableScrollsToNextMealKey = "tableScrollsToNextMealKey"
	
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
	
	//	var regexHelper:WellesleyFreshRegex = WellesleyFreshRegex()
	
	let cellHeight:Int = 60
	
	var data: DataLoader!
	var hasDataLoaded = false
	
	var meals: [String] = [String]()
	
	var defaultDiningHallKey = "defaultDiningHallKey"
	var defaultDiningHall = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if diningHall == "" {
			diningHall = diningHalls[0]
			diningHallName = diningHallFull[0]
		}
		
		if storedData.string(forKey: defaultDiningHallKey) != nil {
			self.defaultDiningHall = storedData.string(forKey: defaultDiningHallKey)!
			if self.defaultDiningHall != "NONE" {
				if diningHallFull.contains(defaultDiningHall) {
					let ind = diningHallFull.index(of: defaultDiningHall)
					diningHall = diningHalls[ind!]
					diningHallName = diningHallFull[ind!]
					self.navigationItem.title = "Menu - \(diningHallName)"
					//					print("Relading table view.")
					//					tableView.reloadData()
				}
			}
		}
		
		loadData()
		
		
		tableScrollsToNextMeal = storedData.bool(forKey: tableScrollsToNextMealKey)
		
		
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
		hallInputView.isHidden = true
		hallInputView.backgroundColor = UIColor.white
		
		self.navigationController?.view.addSubview(hallInputView)
	}
	
	func loadData() {
		// we don't need to load data because the other navigation controllers hopefully do it for me
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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
		
		tableScrollsToNextMeal = storedData.bool(forKey: tableScrollsToNextMealKey)
		loadData()
		
		//		if storedData.string(forKey: defaultDiningHallKey) != nil {
		//			self.defaultDiningHall = storedData.string(forKey: defaultDiningHallKey)!
		//			if self.defaultDiningHall != "NONE" {
		//				if diningHallFull.contains(defaultDiningHall) {
		//					let ind = diningHallFull.index(of: defaultDiningHall)
		//					diningHall = diningHalls[ind!]
		//					diningHallName = diningHallFull[ind!]
		//					self.navigationItem.title = "Menu - \(diningHallName)"
		//					print("Relading table view.")
		//					tableView.reloadData()
		//				}
		//			}
		//		}
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
		
		//		myCell.myTableViewController = self
		return myCell
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
		myHeader.contentView.backgroundColor = UIColor.groupTableViewBackground
		if section == 0 {
			myHeader.nameLabel.text = self.createHeaderTitle() //"\(self.diningHallName) - \(self.data.thirdTodayString)"
			//			myHeader.nameLabel.text = self.diningHallName
			//		myHeader.myTableViewController = self
		} else {
			myHeader.nameLabel.text = ""
		}
		return myHeader
	}
	
	func deleteCell(_ cell: UITableViewCell) {
		if let deletionIndexPath = tableView.indexPath(for: cell) {
			items.remove(at: deletionIndexPath.item)
			tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
		}
	}
	
	// -------------------------------------------------------------
	// --------------------------HELPERS----------------------------
	// -------------------------------------------------------------
	
	func createHeaderTitle() -> String {
		return "\(self.diningHallName) - \(self.data.thirdTodayString)"
	}
	
	
	func madeSelection() {
		self.hallInputView.isHidden = true;
		print("Made selection: \(diningHall).")
		self.navigationItem.title = "Menu - \(diningHallName)"
		choose()
	}
	
	func showPickerView() {
		print("\nShowing picker view.")
		previousDiningHall = diningHall
		if diningHall == "" {
			diningHall = diningHalls[0]
			diningHallName = diningHallFull[0]
		}
		self.hallInputView.isHidden = false
		self.view.bringSubview(toFront: hallInputView)
	}
	
	func retitleHeader() {
		if (tableView.headerView(forSection: 0) != nil) {
			(tableView.headerView(forSection: 0) as! Header).nameLabel.text = createHeaderTitle() //"\(self.diningHallName) - \(self.data.thirdTodayString)"
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
		//		print("Hey there!!!!!!!!")
		retitleHeader()
		if previousDiningHall != diningHall {
			normalArray = diningHallArrays[diningHall] ?? ["Closed"]
			//			if (diningHallArrays[diningHall] != nil) {
			//				normalArray = diningHallArrays[diningHall]!
			//			}
			newCellsInsertion()
			scrollToNextMeal()
		} else if headerTitle() != "" {
			if headerTitle() != diningHallName {
				retitleHeader()
				if (diningHallArrays[diningHall] != nil) {
					normalArray = diningHallArrays[diningHall]!
				}
				newCellsInsertion()
				scrollToNextMeal()
			}
		} else {
			if (diningHallArrays[diningHall] != nil) {
				normalArray = diningHallArrays[diningHall]!
			}
			newCellsInsertion()
		}
		//}
	}
	
	func scrollToNextMeal() {
		if tableScrollsToNextMeal {
			let hours = DiningHours()
			let nextMeal = hours.nextMeal(diningHall)
			
			print("\nscrollToNextMeal()")
			print("Next meal: \(nextMeal)")
			let array:[String] = diningHallArrays[diningHall] ?? ["Closed"]
			let ind = array.index(of: nextMeal)
			if ind != nil {
				print("Index: \(ind)")
				print("\n")
				let ip = IndexPath(row: ind!, section: 0)
				tableView.selectRow(at: ip, animated: true, scrollPosition: .middle)
			}
		}
	}
	
	func refresh() {
		if !loadingHall {
			
			let chosenDiningHall = Int(arc4random_uniform(UInt32(diningHalls.count)))
			retitleHeader()
			//			if (diningHallArrays[diningHall] != nil) {
			// If diningHallArrays[diningHall] is nil, just have it say "Closed"
			normalArray = diningHallArrays[diningHall] ?? ["Closed"]
			//			}
			newCellsInsertion()
			if (previousDiningHall != diningHall) {
				diningHall = diningHalls[chosenDiningHall]
			}
			
			if diningHallArrays.count > 0 {
				let keyExists = diningHallArrays[diningHall] != nil
				if (!keyExists) {
					//					load(diningHall)
				} else {
					normalArray = diningHallArrays[diningHall] ?? ["Closed"]
				}
			} else {
				//				load(diningHall)
			}
		}
	}
	
	
	func newCellsInsertion() {
		print("Inserting new cells.")
		if (normalArray.count >= 1) {
			let originalSize:Int = items.count
			let newSize:Int = normalArray.count
			let delete = newSize < originalSize
			
			print(originalSize, ", ", newSize, separator: "")
			var indexPaths = [IndexPath]()
			var originalPaths = [IndexPath]()
			
			let larger = max(newSize, originalSize)
			let smaller = min(newSize, originalSize)
			
			for i in 0..<larger {
				if i < smaller {
					items[i] = normalArray[i]
					originalPaths.append(IndexPath(row: i, section: 0))
				} else {
					if delete {
						items.removeLast()
					} else {
						items.append(normalArray[i])
					}
					indexPaths.append(IndexPath(row: i, section: 0))
				}
			}
			
			updateTableViewRows(oldPaths: originalPaths, newPaths: &indexPaths, newSize: newSize, oldSize: originalSize, delete: delete)
		}
	}
	
	func absDiffInt(val1: Int, val2: Int) -> Int {
		return Int(abs(val1 - val2))
	}
	
	func updateTableViewRows(oldPaths: [IndexPath], newPaths: inout [IndexPath], newSize: Int, oldSize: Int, delete: Bool) {
		var bottomHalfIndexPaths = [IndexPath]()
		let isAbsoluteDiffGreaterThanOne = absDiffInt(val1: newSize, val2: oldSize) > 1
		print("newPaths count: \(newPaths.count)")
		print("absolute diff: \(isAbsoluteDiffGreaterThanOne)")
		
		if (isAbsoluteDiffGreaterThanOne) {
			bottomHalfIndexPaths = lastHalfOfIndexPaths(indexPaths: &newPaths)
		}
		
		tableView.beginUpdates()
		tableView.reloadRows(at: oldPaths, with: .fade)
		if delete {
			if isAbsoluteDiffGreaterThanOne {
				tableView.deleteRows(at: newPaths, with: .right)
				tableView.deleteRows(at: bottomHalfIndexPaths, with: .left)
			} else if newPaths.count > 0 {
				tableView.deleteRows(at: newPaths, with: .right)
			}
		} else {
			if (isAbsoluteDiffGreaterThanOne) {
				tableView.insertRows(at: newPaths, with: .right)
				tableView.insertRows(at: bottomHalfIndexPaths, with: .left)
			} else if newPaths.count > 0 {
				tableView.insertRows(at: newPaths, with: .right)
			}
		}
		tableView.endUpdates()
	}
	
	func lastHalfOfIndexPaths(indexPaths: inout [IndexPath]) -> [IndexPath] {
		var bottomHalfIndexPaths = [IndexPath]()
		for _ in 0..<indexPaths.count / 2 {
			bottomHalfIndexPaths.append(indexPaths.removeLast())
		}
		return bottomHalfIndexPaths
	}
	
	func saveDiningHallArrays(_ hall: String) {
		self.storedData.set(self.diningHallArrays, forKey: self.diningHallDictionaryKey)
		for i in 0...(self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]!.count - 1 {
			print("The new string: |\((self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]![i])|")
		}
		
		countMeals()
		print("Number of meals: \(self.meals.count)")
		print("Meal counts: \(self.mealItemCounts)")
	}
	
	
	// Function for DataLoader to call once it's done adding data to MenuViewController
	func doneAssigning() {
		print("\nDone assigning.")
		//		print("\(self.diningHallArrays[self.diningHall])\n")
		//		print("\(self.diningHall)")
		if self.diningHallArrays[self.diningHall] != nil {
			let dh = DiningHours()
			print("Dining Hall: \(self.diningHall)")
			if dh.closedAllDay(diningHall) {
				self.items = ["Closed"]
			} else {
				self.items = self.diningHallArrays[self.diningHall]!
			}
			retitleHeader()
			self.tableView.reloadData()
		} else {
			self.items = ["Closed"]
			self.tableView.reloadData()
		}
	}
	
	func countMeals() {
		// Clear meals.
		meals = [String]()
		mealItemCounts = Array(repeating: 0, count: 3)
		
		for i in 0..<items.count {
			switch items[i] {
			case "Breakfast", "Lunch", "Dinner":
				meals.append(items[i])
			default:
				break
			}
		}
		
		let mealArray = ["Breakfast", "Lunch", "Dinner"]
		
		var index = -1
		for i in 0..<items.count {
			print("Item \(items[i])")
			if !mealArray.contains(items[i]) && items[i] != "Closed" {
				print("Meal \(mealArray[index]): \(items[i])")
				mealItemCounts[index] += 1
			} else {
				index += 1
			}
		}
	}
}
