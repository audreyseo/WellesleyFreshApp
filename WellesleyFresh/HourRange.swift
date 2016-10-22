//
//  HourRange.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import Foundation
import UIKit


class HourRange {
	var highHour:Double
	var lowHour:Double
	var rangeName:String
	var hourFormatter:NSDateFormatter
	var minuteFormatter:NSDateFormatter
	
	init( low:Double, high:Double, name:String) {
		self.highHour = high;
		self.lowHour = low;
		self.rangeName = name;
		self.hourFormatter = NSDateFormatter()
		hourFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		hourFormatter.dateFormat = "k"
		minuteFormatter = NSDateFormatter()
		minuteFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		minuteFormatter.dateFormat = "m"
	}
	
	func currentHour() -> Double {
		let today:NSDate
		today = NSDate.init()
		let h:Int = Int(hourFormatter.stringFromDate(today))!
		let m:Int = Int(minuteFormatter.stringFromDate(today))!
		let hour:Double = Double(h)
		let minute:Double = Double(m)
		return (hour + (minute / 60.0))
	}
	
	func withinRange() -> Bool {
		let hour:Double = currentHour()
		if hour < highHour && hour > lowHour {
			return true
		}
		return false
	}
	
	func name() -> String {
		return rangeName
	}
	
	func timeLeft() -> Double {
		let hour:Double = currentHour()
		if withinRange() {
			return highHour - hour
		} else {
			return -1.0
		}
	}
	
	func percentTimeElapsed() -> Double {
		let total = highHour - lowHour;
		let elapsed = currentHour() - lowHour;
		return 100.0 * (elapsed / total)
	}
}