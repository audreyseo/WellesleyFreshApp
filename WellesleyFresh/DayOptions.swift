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
	var formatter:NSDateFormatter
	
	init(initialDays:[String]) {
		days = initialDays
		formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		formatter.dateFormat = "EEEEEE"
	}
	
	func hasToday()-> Bool {
		let today:NSDate
		today = NSDate.init()
		let day = formatter.stringFromDate(today)
		for i in 0...days.count - 1 {
			if (days[i].containsString(day)) {
				return true;
			}
		}
		return false;
	}
	
	func getOption() -> Int {
		let today:NSDate
		today = NSDate.init()
		let day = formatter.stringFromDate(today)
		for i in 0...days.count - 1 {
			if days[i].containsString(day) {
				return i
			}
		}
		return -1;
	}
}