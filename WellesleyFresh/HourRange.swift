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
	var secondFormatter:NSDateFormatter
	var timeFormatter:NSDateFormatter
	
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
		secondFormatter = NSDateFormatter()
		secondFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		secondFormatter.dateFormat = "s"
		timeFormatter = NSDateFormatter()
		timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		timeFormatter.dateFormat = "kk:mm:ss"
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
	
	func hours() -> Int {
		let today:NSDate
		today = NSDate.init()
		return Int(hourFormatter.stringFromDate(today))!
	}
	
	func hoursLeft() -> Int {
		var h:Int = hours()
//		print("\(h), \(Int(highHour)), \(highHour)")
		if (highHour == 0) {
			if lowHour % 1.0 == 0.5 {
				let m = minutes()
				if (m > 30) {
					return 24 - (h + 1)
				} else {
					return 24 - h
				}
			} else {
				return 24 - h
			}
		}
		if (highHour % 1 == 0) {
			let m = minutes()
			if (m > 30) {
				return Int(highHour) - (h + 1)
			} else {
				return Int(highHour) - h
			}
		} else if highHour % 1 == 0.5 {
			let m = minutes()
			if m <= 30 {
				h += 1
			}
			return Int(highHour) - h
		}
		return Int(highHour) - h
	}
	
	func hoursElapsed() -> Int {
		var h:Int = hours()
		let m:Int = minutes()
		if lowHour % 1 == 0.5 {
			if m > 30 {
				h += 1;
			}
		}
//		print("\(h), \(Int(lowHour)), \(lowHour)")
		return h - Int(round(lowHour))
	}
	
	func minutes() -> Int {
		let today:NSDate
		today = NSDate.init()
		return Int(minuteFormatter.stringFromDate(today))!
	}
	
	func minutesLeft() -> Int {
		var m:Int = minutes()
		if highHour % 1 == 0.5 {
			if m >= 30 {
				m += 30
			}
		}
		if (m != 0) {
			return 60 - m
		}
		else {
			return m
		}
	}
	
	func minutesElapsed() -> Int {
		var m:Int = minutes()
		if lowHour % 1 == 0.5 {
			if m >= 30 {
				m = m - 30
			} else {
				m = 60 + (m - 30)
			}
		}
		return m
	}
	
	func seconds() -> Int {
		let today:NSDate
		today = NSDate.init()
		return Int(secondFormatter.stringFromDate(today))!
	}
	
	func secondsLeft() -> Int {
		return 59 - seconds()
	}
	
	func secondsElapsed() -> Int {
		return seconds()
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