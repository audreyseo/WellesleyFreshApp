//
//  DataLoader.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 19/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import Foundation

class DataLoader {
	var diningHalls: [String]
	var newDiningHalls = ["bae-pao-lu-chow", "bates", "tower", "stone-davis", "pomeroy"]
	var newToOld:[String: String] = ["bae-pao-lu-chow": "bplc", "bates": "bates", "tower": "tower", "stone-davis": "stonedavis", "pomeroy": "pomeroy"]
	var dataArray: [String]
	var regexHelper: WellesleyFreshRegex
	var todayString: String
	var otherTodayString: String
	var thirdTodayString: String
	var storedData: UserDefaults
	let diningHallDictionaryKey:String = "diningHallDictionaryKey"
	let todaysDateKey:String = "todaysDateKey"
//	var diningHallArrays: [String: [String]] = [String: [String]]()
	var diningHall: String = ""
	var menuVC: MenuViewController
	var meal = [String: [String: [String: String]]]()
	var menu = [String: [String]]()
	var successes = 0
//	let hours = DiningHours()
	
	init(diningHalls: [String], menuViewController: MenuViewController) {
		// Init
		self.diningHalls = diningHalls
		self.dataArray = [String]()
		self.regexHelper = WellesleyFreshRegex()
		self.storedData = UserDefaults()
		self.menuVC = menuViewController
		
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
		
		MyDateFormatter.dateFormat = "YYYY/M/d"
		
		otherTodayString = MyDateFormatter.string(from: today)
		
		MyDateFormatter.dateFormat = "YYYY-MM-d"
		thirdTodayString = MyDateFormatter.string(from: today)
		
		print(otherTodayString, thirdTodayString)
		
		menuVC.todayString = todayString
		
		
		// Use the following two lines for debugging purposes, specifically for debugging the regex parsing
		// and string manipulation, as well as behavior of json parser.
//		todayString = "1003"
//		storedData.set("1004", forKey: todaysDateKey)
//		todayString = "0127"
//		otherTodayString = "2017/1/27"
//		thirdTodayString = "2017-01-27"
		
		if hasRunAppBefore() && hasAlreadyDownloadedDataToday() {
			print("DataLoader Already got data today.")
			menuVC.diningHallArrays = storedData.dictionary(forKey: diningHallDictionaryKey) as! [String:[String]]
		} else {
			if hasRunAppBefore() {
				print("DataLoader Needed to get data for today.")
			}
			setDateAndDownload()
		}
	}
	
	func setDateAndDownload() {
		storedData.setValue(todayString, forKey: todaysDateKey)
		preload()
		refresh()
	}
	
	func hasAlreadyDownloadedDataToday() -> Bool {
		if hasRunAppBefore() {
			return storedData.string(forKey: todaysDateKey) == todayString
		}
		return false
	}
	
	func hasRunAppBefore() -> Bool {
		return storedData.string(forKey: todaysDateKey) != nil
	}
	
	
	
	func trimDataArray() {
		for i in 0..<self.dataArray.count {
			self.dataArray[i] = self.dataArray[i].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		}
		
		var indexer = 0
		for _ in 0..<self.dataArray.count {
			
			if self.dataArray[indexer] == "" {
//				print("\n\nDataLoader\n|\(self.dataArray[indexer])|\nDataLoader\n\n")
				self.dataArray.remove(at: indexer)
				indexer -= 1
			}
			indexer += 1
			
			if indexer == self.dataArray.count {
				break
			}
		}
	}
	
	func preload() {
		for i in 0...diningHalls.count - 1 {
			load(diningHalls[i])
			loadNew(newDiningHalls[i])
		}
	}
	
	func refresh() {
//		if !loadingHall {
		
			let chosenDiningHall = Int(arc4random_uniform(UInt32(diningHalls.count)))
			menuVC.retitleHeader()
			if (menuVC.diningHallArrays[diningHall] != nil) {
				dataArray = menuVC.diningHallArrays[diningHall]!
			}
			menuVC.newCellsInsertion()
			if (menuVC.previousDiningHall != menuVC.diningHall) {
				menuVC.diningHall = diningHalls[chosenDiningHall]
			}
			
			if menuVC.diningHallArrays.count > 0 {
				let keyExists = menuVC.diningHallArrays[diningHall] != nil
				if (!keyExists) {
					load(diningHall)
				} else {
					dataArray = menuVC.diningHallArrays[diningHall]!
				}
			} else {
				load(diningHall)
			}
//		}
	}
	
//	func saveDiningHallArrays(_ hall: String) {
//		self.storedData.set(self.diningHallArrays, forKey: self.diningHallDictionaryKey)
//		for i in 0...(self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]!.count - 1 {
//			print("The new string: ", (self.storedData.dictionary(forKey: self.diningHallDictionaryKey) as! [String: [String]])[hall]![i], separator: "")
//		}
//	}
	
	func getDiningHallUrlRequest(_ hall: String) -> URLRequest {
		let urlString = "http://www.wellesleyfresh.com/menus/" + hall + "/menu_" + todayString + ".htm"
		return URLRequest(url: URL(string: urlString)!)
	}
	
	func makeRestApiDiningHallUrlRequest(_ hall: String) -> URLRequest {
		let urlString = "http://wellesleyfresh.nutrislice.com/menu/api/digest/school/\(hall)/menu-type/breakfast/date/\(otherTodayString)"
		return URLRequest(url: URL(string: urlString)!)
	}
	
	func makeRestApiDiningHallUrlRequest(_ hall: String, type: String) -> URLRequest {
		var hallNum = ""
		var typeNum = ""
		switch hall {
		case "bae-pao-lu-chow":
			hallNum = "43"
		case "bates":
			hallNum = "44"
		case "pomeroy":
			hallNum = "45"
		case "stone-davis":
			hallNum = "46"
		case "tower":
			hallNum = "47"
		default:
			break
		}
		
		switch type {
		case "breakfast":
			typeNum = "34"
		case "lunch":
			typeNum = "35"
		case "dinner":
			typeNum = "36"
		default:
			break
		}
		
		let urlString = "http://wellesleyfresh.nutrislice.com/menu/api/weeks/school/\(hallNum)/menu-type/\(typeNum)/\(otherTodayString)/"
		//"http://wellesleyfresh.nutrislice.com/menu/api/digest/school/\(hall)/menu-type/\(type)/date/\(otherTodayString)"
		return URLRequest(url: URL(string: urlString)!)
	}
	
	
	// Load the information from a specific dining hall
	func load(_ hall:String) {
		menuVC.loadingHall = true
		print("DataLoader loading hall ", hall)
		
		// Get the url for the specific dining hall
		let request = getDiningHallUrlRequest(hall)
		
		// Create the task + the completion handler for the url session
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			// Strings are Windows 1252 encoded for some reason
			let mystring:String! = String(data: data!, encoding: .windowsCP1252)
			//			print("My string: \n\(mystring)")
			
			let bodyString:String = self.regexHelper.extractInformationString(mystring as String)
			//			print("\n\n\n\n\nDigest string:\n|", bodyString, "|\nEnd of string", separator: "")
			
			self.dataArray = bodyString.components(separatedBy: "\n")
			self.trimDataArray()
			
			if self.menuVC.diningHallArrays[hall]?.count != self.dataArray.count {
				self.menuVC.diningHallArrays[hall] = self.dataArray
				self.menuVC.saveDiningHallArrays(hall)
			}
			
			self.menuVC.loadingHall = false;
			
			}.resume()
	}
	
	func recordMeal(hall: String, mealName: String, lastStation: String, newVal: String) {
		var temp = self.meal[hall]?[mealName]?[lastStation]
		if temp != nil {
			temp = temp! + ", \(newVal)"
		} else if lastStation == "Breakfast" {
			if temp != nil {
				temp = temp! + ", \(newVal)"
			} else {
				temp = "\(newVal)"
			}
		} else {
			temp = "\(newVal)"
		}
		
		self.meal[hall]?[mealName]?[lastStation] = temp
	}
	
	func getDaysArray(_ data: Data?) -> [[String: Any]]? {
		do {
			let json = try JSONSerialization.jsonObject(with: data!, options: [])
			print("getDaysArray(): Succeeded.")
			
			let dictionary = json as! [String: Any]
			let daysArray = dictionary["days"] as! [[String: Any]]
			
//			var array: [[String: Any]]?
			for d in 0..<daysArray.count {
				let dict = daysArray[d] //as! [String: Any]
				let date = dict["date"] as! String
				//						print("\(hall) \(types[i]): date: |\(date)| vs |\(self.thirdTodayString)|")
				if date == self.thirdTodayString {
					//							print("\(hall) \(types[i]): Found the right date")
					//							ind = i
					return dict["menu_items"] as? [[String: Any]]
//					break;
				}
			}
			return nil
		} catch {
			print("getDaysArray(): Error occurred in JSON serialization.")
			return nil
		}
	}
	
	
	func loadNew(_ hall: String) {
		let types = ["breakfast", "lunch", "dinner"]
		var reqs = [URLRequest]()
		for i in 0..<types.count {
			reqs.append(makeRestApiDiningHallUrlRequest(hall, type: types[i]))
		}
		
		var lastStation = "Breakfast"
		self.meal[hall] = [String: [String: String]]()
		for i in 0..<types.count {
			print("")
			URLSession.shared.dataTask(with: reqs[i]) { (data, response, error) in
//				let mystring: String! = String(data: data!, encoding: .utf8)
//				print("\n\nNew Version: |\(mystring)|\n\n")
				
				var id = 0
				
				self.meal[hall]?[types[i]] = [String: String]()
				let array = self.getDaysArray(data)
				
				
				if array != nil {
					for item in array! {
						let isSectionTitle = item["is_section_title"] as? Bool
						let isStationHeader = item["is_station_header"] as? Bool
						if isSectionTitle != nil || isStationHeader != nil {
							if isSectionTitle! || isStationHeader! {
								lastStation = item["text"] as! String
								if let num = item["station_id"] as? Int {
									id = num
								}
							}
						}
						
						if let val = item["food"] as? [String: Any] {
							//												print("Food name: \(val["name"])")
							if val["name"] != nil {
								self.recordMeal(hall: hall, mealName: types[i], lastStation: lastStation, newVal: val["name"] as! String)
							}
						}
						
						if let rawVal = item["text"] {
							if let num = item["station_id"] as? Int {
								if num == id {
									if item["text"] as! String != lastStation {
										if let val = rawVal as? String {
											if val != "" {
												self.recordMeal(hall: hall, mealName: types[i], lastStation: lastStation, newVal: val)
											}
										}
									}
								}
							}
						}
					}
				}
				
				self.createMenu()
				
			}.resume()
		}
	}
	
	func createMenu() {
		let types = ["breakfast", "lunch", "dinner"]
		self.successes += 1
		if self.successes == (5 * 3) {
			for (h, tmpMenu) in self.meal {
				self.menu[self.newToOld[h]!] = [String]()
				//						for (key, val) in menu {
				for m in types {
					if tmpMenu[m]!.count > 0 {
						self.menu[self.newToOld[h]!] = self.menu[self.newToOld[h]!]! + [(m as NSString).capitalized]
						//								self.menu[h].append(m)
						//							print("\(h), \(key), \(val)")
						for (k, v) in  tmpMenu[m]! {
							self.menu[self.newToOld[h]!]!.append("\(k) - \(v)")
							//								print("\(hall) \(key): \(k): \(v)")
						}
					}
				}
			}
			
			for (h, tmpMenu) in self.menu {
				print("\n\(h)")
				for item in tmpMenu {
					print("\(item)")
				}
				if tmpMenu.count > 3 {
					self.menuVC.diningHallArrays[h] = tmpMenu
					self.menuVC.saveDiningHallArrays(h)
				}
			}
		} else {
			print("Successes: \(self.successes)")
		}
	}
}
