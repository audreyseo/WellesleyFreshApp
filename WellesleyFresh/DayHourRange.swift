//
//  DayHourRange.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 26/12/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit


class DayHourRange:HourRange {
	var lowDay = -1
	var highDay = -1
	var dayFormatter:DateFormatter
	
	init( lowHour:Double, highHour:Double, name:String, lowDay:Int, highDay:Int) {
		super.init(low: lowHour, high: highHour, name: name)
		self.lowDay = lowDay
		self.highDay = highDay
		//self.highHour = high;
		//self.lowHour = low;
		//self.rangeName = name;
		//self.hourFormatter = DateFormatter()
		//hourFormatter.locale = Locale(identifier: "en_US_POSIX")
		//hourFormatter.dateFormat = "k"
		//minuteFormatter = DateFormatter()
		//minuteFormatter.locale = Locale(identifier: "en_US_POSIX")
		//minuteFormatter.dateFormat = "m"
		//secondFormatter = DateFormatter()
		//secondFormatter.locale = Locale(identifier: "en_US_POSIX")
		//secondFormatter.dateFormat = "s"
		//timeFormatter = DateFormatter()
		//timeFormatter.locale = Locale(identifier: "en_US_POSIX")
		//timeFormatter.dateFormat = "kk:mm:ss"
	}
	
	init(lowHour:Double, highHour:Double, name:String, dayChange:Int) {
		super.init(low: lowHour, high: highHour, name: name)
		
		dayFormatter = DateFormatter()
		dayFormatter.locale = Locale(identifier: "en_US_POSIX")
		dayFormatter.dateFormat = "d"
		let today:Date = Date.init()
		lowDay = Int(dayFormatter.string(from: today))!
		highDay = lowDay + dayChange
		
		//self.highHour = high;
		//self.lowHour = low;
		//self.rangeName = name;
		//self.hourFormatter = DateFormatter()
		//hourFormatter.locale = Locale(identifier: "en_US_POSIX")
		//hourFormatter.dateFormat = "k"
		//minuteFormatter = DateFormatter()
		//minuteFormatter.locale = Locale(identifier: "en_US_POSIX")
		//minuteFormatter.dateFormat = "m"
		//secondFormatter = DateFormatter()
		//secondFormatter.locale = Locale(identifier: "en_US_POSIX")
		//secondFormatter.dateFormat = "s"
		//timeFormatter = DateFormatter()
		//timeFormatter.locale = Locale(identifier: "en_US_POSIX")
		//timeFormatter.dateFormat = "kk:mm:ss"
	}
	
	override func currentHour() -> Double {
		let today:Date = Date.init()
		let todayDate = getDate(aDate: today)
		let todayHour = getHour(aDate: today)
		var totalHours:Double = 0.0
		
		var diff:Double = Double(todayDate - lowDay)
		
		if diff > 0 {
			totalHours += (24 - lowHour)
			diff -= 1.0
			let diff1 = highDay - todayDate
			if diff1 == 0 {
				diff -= 1.0
				return totalHours + Double(todayHour) + (diff * 24.0)
			}
			return totalHours + Double(todayHour)
		} else {
			return Double(todayHour) - lowHour
		}
	}
	
	
	func getDate(aDate:Date) -> Int {
		return Int(dayFormatter.string(from: aDate))!
	}
}
