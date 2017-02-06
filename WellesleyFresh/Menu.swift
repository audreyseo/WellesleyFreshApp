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
	
	
	init(rawString: String) {
		
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
	
	func createMenu() {
		let newDiningHalls = ["bae-pao-lu-chow", "bates", "tower", "stone-davis", "pomeroy"]
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
			self.menu[newToOld[h]!] = [String]()
			//						for (key, val) in menu {
			for m in types {
				if tmpMenu[m] != nil {
					if tmpMenu[m]!.count > 0 {
						self.menu[newToOld[h]!] = self.menu[newToOld[h]!]! + [(m as NSString).capitalized]
						//								self.menu[h].append(m)
						//							print("\(h), \(key), \(val)")
						for (k, v) in  tmpMenu[m]! {
							self.menu[newToOld[h]!]!.append("\(k) - \(v)")
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
}
