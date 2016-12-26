//
//  DayOptions.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit


class DayOptions {
	var days:[String] = [String]()
	var formatter:DateFormatter
	
	init(initialDays:[String]) {
		days = initialDays
		formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "EEEEEE"
	}
	
	func hasToday()-> Bool {
		let today:Date
		today = Date.init()
		let day = formatter.string(from: today)
		for i in 0...days.count - 1 {
			if (days[i].contains(day)) {
				return true;
			}
		}
		return false;
	}
	
	func getOption() -> Int {
		let today:Date
		today = Date.init()
		let day = formatter.string(from: today)
		for i in 0...days.count - 1 {
			if days[i].contains(day) {
				return i
			}
		}
		return -1;
	}
}
