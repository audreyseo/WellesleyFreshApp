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
	var dataArray: [String]
	var regexHelper: WellesleyFreshRegex
	var todayString: String
	var otherTodayString: String
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
		print(otherTodayString)
		otherTodayString = "2017/1/27"
		
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
		
		let hours = DiningHours()
		
		let rq = makeRestApiDiningHallUrlRequest(hall)
		
		URLSession.shared.dataTask(with: rq) { (data, response, error) in
			let mystring: String! = String(data: data!, encoding: .utf8)
			print("\n\nNew Version: |\(mystring)|\n\n")
			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				let dictionary = json as! [String: Any]
				print("Succeeded.")
				for (k, v) in dictionary {
					print("New Version: \(k): \(v)")
				}
			} catch {
				print("Error occurred.")
			}
		}.resume()
	}
}
