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
		otherTodayString = "2017/1/27"
		thirdTodayString = "2017-01-27"
		
		menuVC.todayString = todayString
		
		
		// Use the following two lines for debugging purposes, specifically for debugging the regex parsing
		// and string manipulation.
				todayString = "1003"
				storedData.set("1004", forKey: todaysDateKey)
		
		if hasRunAppBefore() && hasAlreadyDownloadedDataToday() {
//			if hasAlreadyDownloadedDataToday() {
				print("DataLoader Already got data today.")
				menuVC.diningHallArrays = storedData.dictionary(forKey: diningHallDictionaryKey) as! [String:[String]]
//				menuVC.diningHallArrays = diningHallArrays
//			} else {
//				print("DataLoader Needed to get data for today.")
//				storedData.setValue(todayString, forKey: todaysDateKey)
//				preload()
//				refresh()
//				setDateAndDownload()
//			}
		} else {
			if hasRunAppBefore() {
				print("DataLoader Needed to get data for today.")
			}
//			storedData.setValue(todayString, forKey: todaysDateKey)
//			preload()
//			refresh()
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
			
			self.menuVC.diningHallArrays[hall] = self.dataArray
			self.menuVC.saveDiningHallArrays(hall)
			
			self.menuVC.loadingHall = false;
			
			}.resume()
		
		
//		let rq = makeRestApiDiningHallUrlRequest(hall)
//		
//		URLSession.shared.dataTask(with: rq) { (data, response, error) in
//			let mystring: String! = String(data: data!, encoding: .utf8)
//			print("\n\nNew Version: |\(mystring)|\n\n")
//			do {
//				let json = try JSONSerialization.jsonObject(with: data!, options: [])
//				let dictionary = json as! [String: Any]
//				print("Succeeded.")
//				for (k, v) in dictionary {
//					print("New Version: \(k): \(v)")
//				}
//			} catch {
//				print("Error occurred.")
//			}
//		}.resume()
	}
	
	func loadNew(_ hall: String) {
		let types = ["breakfast", "lunch", "dinner"]
		var reqs = [URLRequest]()
		for i in 0..<types.count {
			reqs.append(makeRestApiDiningHallUrlRequest(hall, type: types[i]))
		}
		
		var lastStation = "Breakfast"
		
		for i in 0..<types.count {
			print("")
			URLSession.shared.dataTask(with: reqs[i]) { (data, response, error) in
				let mystring: String! = String(data: data!, encoding: .utf8)
//				print("\n\nNew Version: |\(mystring)|\n\n")
				do {
					let json = try JSONSerialization.jsonObject(with: data!, options: [])
					print("\(hall) \(types[i]): Succeeded.")
					let dictionary = json as! [String: Any]
					let daysArray = dictionary["days"] as! [[String: Any]]
					
					var id = 0
					
					
					var meal = [String: String]()
					var array: [[String: Any]]!
					for d in 0..<daysArray.count {
						let dict = daysArray[d] //as! [String: Any]
						let date = dict["date"] as! String
//						print("\(hall) \(types[i]): date: |\(date)| vs |\(self.thirdTodayString)|")
						if date == self.thirdTodayString {
//							print("\(hall) \(types[i]): Found the right date")
//							ind = i
							array = dict["menu_items"] as! [[String: Any]]
							break;
						}
					}
					let possibles = ["is_section_title", "food", "text", "is_station_header", "station_id"]
//							print(dict)
					for item in array {
//								print("\n")
						if let isSectionTitle = item["is_section_title"] as? Bool {
							if isSectionTitle {
								lastStation = item["text"] as! String
								if let num = item["station_id"] as? Int {
									id = num
								}
							}
						}
						
						if let isStationHeader = item["is_station_header"] as? Bool {
							if isStationHeader {
								lastStation = item["text"] as! String
								if let num = item["sattion_id"] as? Int {
									id = num
								}
							}
						}
						
						if let val = item["food"] as? [String: Any] {
							//												print("Food name: \(val["name"])")
							if val["name"] != nil {
								if meal[lastStation] != nil {
									meal[lastStation] = meal[lastStation]! + ", \(val["name"] as! String)"
								} else if lastStation == "Breakfast" {
									if meal[lastStation] != nil {
										meal[lastStation] = meal[lastStation]! + ", \(val["name"] as! String)"
									} else {
										meal[lastStation] = "\(val["name"] as! String)"
									}
								} else {
									meal[lastStation] = "\(val["name"] as! String)"
								}
							}
						}
						
						if let rawVal = item["text"] {
							if let num = item["station_id"] as? Int {
								if num == id {
									if item["text"] as! String != lastStation {
										if let val = rawVal as? String {
											if val != "" {
												if meal[lastStation] != nil {
													meal[lastStation] = meal[lastStation]! + ", \(val)"
												} else {
													meal[lastStation] = "\(val)"
												}
											}
										}
									}
								}
							}
						}
						
//						for (k, v) in item {
//							if possibles.contains(k) {
//								if k == "is_section_title" {
//									if v as! Bool == true {
//										lastStation = item["text"] as! String
////												meal[lastStation] = ""
//										if let num = item["station_id"] as? Int {
//											id = num
//										}
//									}
//								}
////										print("New Version for \(hall) \(types[i]): \(k): \(v)")
//								if k == "food" {
//									if let val = v as? [String: Any] {
////												print("Food name: \(val["name"])")
//										if val["name"] != nil {
//											if meal[lastStation] != nil {
//												meal[lastStation] = meal[lastStation]! + ", \(val["name"] as! String)"
//											} else if lastStation == "Breakfast" {
//												if meal[lastStation] != nil {
//													meal[lastStation] = meal[lastStation]! + ", \(val["name"] as! String)"
//												} else {
//													meal[lastStation] = "\(val["name"] as! String)"
//												}
//											} else {
//												meal[lastStation] = "\(val["name"] as! String)"
//											}
//										}
//									}
//								} else if k == "text" {
//									if let num = item["station_id"] as? Int {
//										if num == id {
//											if item["text"] as! String != lastStation {
//												if let val = v as? String {
//													if val != "" {
//														if meal[lastStation] != nil {
//															meal[lastStation] = meal[lastStation]! + ", \(val)"
//														} else {
//															meal[lastStation] = "\(val)"
//														}
//													}
//												}
//											}
//										}
//									}
//								}
//							}
//						}
					}
//							print("\n\n")
					
					for (k, v) in meal {
						print("\(hall) \(types[i]): \(k): \(v)")
					}
				} catch {
					print("Error occurred with hall \(hall), meal: \(reqs[i]).")
				}
			}.resume()
		}
	}
}
