//
//  Menu.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 6/2/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import Foundation


class Menu {
	var name: String = ""
	var meal = [String: [String: [String: String]]]()
	var menu = [String: [String]]()
	var successes = 0
	var thirdTodayString: String
	
	init(hall: String) {
		self.name = hall
	}
	
	
//	init(hall: String, meal: String, lastStation: inout String, rawData: Data) {
//		let today = Date()
//		
//		let MyDateFormatter = DateFormatter()
//		MyDateFormatter.locale = Locale(identifier: "en_US_POSIX")
//		MyDateFormatter.dateFormat = "YYYY-MM-dd"
//		thirdTodayString = MyDateFormatter.string(from: today)
//		
//		self.meal[hall]?[meal] = [String: String]()
//		
//		let array = self.getDaysArray(rawData)
//		
//		self.parseData(hall: hall, mealName: meal, lastStation: &lastStation, array: array)
//	}
	
	func addMenu(meal: String, lastStation: inout String, rawData: Data) {
		let today = Date()
		
		let MyDateFormatter = DateFormatter()
		MyDateFormatter.locale = Locale(identifier: "en_US_POSIX")
		MyDateFormatter.dateFormat = "YYYY-MM-dd"
		thirdTodayString = MyDateFormatter.string(from: today)
		
		self.meal[hall]?[meal] = [String: String]()
		
		let array = self.getDaysArray(rawData)
		
		self.parseData(hall: hall, mealName: meal, lastStation: &lastStation, array: array)
	}
	
	
	
	func createMenu() {
//		let newDiningHalls = ["bae-pao-lu-chow", "bates", "tower", "stone-davis", "pomeroy"]
		let newToOld:[String: String] = ["bae-pao-lu-chow": "bplc", "bates": "bates", "tower": "tower", "stone-davis": "stonedavis", "pomeroy": "pomeroy"]
		
		let types = ["breakfast", "lunch", "dinner"]
//		self.successes += 1
//		if self.successes == (5 * 3) {
		print("Creating menu.")
		print("\n\nMeals:\n\(self.meal)\n\n")
		for (k, v) in self.meal {
			print("\(k): \(v)")
		}
		for (h, tmpMenu) in self.meal {
			let convertedHall = newToOld[h]!
			self.menu[convertedHall] = [String]()
			//						for (key, val) in menu {
			for m in types {
				if tmpMenu[m] != nil {
					if tmpMenu[m]!.count > 0 {
						self.menu[convertedHall] = self.menu[convertedHall]! + [(m as NSString).capitalized]
						//								self.menu[h].append(m)
						//							print("\(h), \(key), \(val)")
						for (k, v) in  tmpMenu[m]! {
							self.menu[convertedHall]!.append("\(k) - \(v)")
							//								print("\(hall) \(key): \(k): \(v)")
						}
					}
				}
			}
		}
		
//			for (h, tmpMenu) in self.menu {
//				print("\n\(h)")
//				for item in tmpMenu {
//					print("\(item)")
//				}
//				if tmpMenu.count > 3 {
//					print("\nSaving menu.")
//					self.menuVC.diningHallArrays[h] = tmpMenu
//					self.menuVC.saveDiningHallArrays(h)
//				}
//			}
//
//			storedData.set(week.dateRange, forKey: weekRangeKey)
//		} else {
//			print("Successes: \(self.successes)")
//		}
	}
	
	
	func getDaysArray(_ data: Data?) -> [[String: Any]]? {
		//		var error: Error
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
			print("Could not find the date \(self.thirdTodayString) in this data.")
			return nil
		} catch let error as Error {
			print("\n\ngetDaysArray(): Error occurred in JSON serialization.")
			print("getDaysArray(): \(error)")
			let mystring: String! = String(data: data!, encoding: .utf8)
			print("New Version: |\(mystring)|\n\n")
			return nil
		}
	}
	
	func parseData(hall: String, mealName: String, lastStation: inout String, array: [[String: Any]]?) {
		var id = 0
		//		let types = ["breakfast", "lunch", "dinner"]
		print("Array not nil?: \(array != nil)")
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
						self.recordMeal(hall: hall, mealName: mealName, lastStation: lastStation, newVal: val["name"] as! String)
					}
				}
				
				if let rawVal = item["text"] {
					if let num = item["station_id"] as? Int {
						if num == id {
							if item["text"] as! String != lastStation {
								if let val = rawVal as? String {
									if val != "" {
										self.recordMeal(hall: hall, mealName: mealName, lastStation: lastStation, newVal: val)
									}
								}
							}
						}
					}
				}
			}
		}
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
		
		if self.meal[hall] == nil {
			self.meal[hall] = [String: [String: String]]()
		}
		
		if self.meal[hall]?[mealName] == nil {
			self.meal[hall]?[mealName] = [String: String]()
		}
		
		print("\(hall):\(mealName):\(lastStation):\(temp)")
		
		self.meal[hall]?[mealName]?[lastStation] = temp
		
	}
}
