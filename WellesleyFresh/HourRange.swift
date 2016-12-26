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
	var hourFormatter:DateFormatter
	var minuteFormatter:DateFormatter
	var secondFormatter:DateFormatter
	var timeFormatter:DateFormatter
	
	init( low:Double, high:Double, name:String) {
		self.highHour = high;
		self.lowHour = low;
		self.rangeName = name;
		self.hourFormatter = DateFormatter()
		hourFormatter.locale = Locale(identifier: "en_US_POSIX")
		hourFormatter.dateFormat = "k"
		minuteFormatter = DateFormatter()
		minuteFormatter.locale = Locale(identifier: "en_US_POSIX")
		minuteFormatter.dateFormat = "m"
		secondFormatter = DateFormatter()
		secondFormatter.locale = Locale(identifier: "en_US_POSIX")
		secondFormatter.dateFormat = "s"
		timeFormatter = DateFormatter()
		timeFormatter.locale = Locale(identifier: "en_US_POSIX")
		timeFormatter.dateFormat = "kk:mm:ss"
	}
	
	func currentHour() -> Double {
		let today:Date
		today = Date.init()
		let h:Int = Int(hourFormatter.string(from: today))!
		let m:Int = Int(minuteFormatter.string(from: today))!
		let hour:Double = Double(h)
		let minute:Double = Double(m)
		return (hour + (minute / 60.0))
	}
	
	func hours() -> Int {
		let today:Date
		today = Date.init()
		return Int(hourFormatter.string(from: today))!
	}
	
	func hoursLeft() -> Int {
		var h:Int = hours()
//		print("\(h), \(Int(highHour)), \(highHour)")
		if (highHour == 0) {
			if lowHour.truncatingRemainder(dividingBy: 1.0) == 0.5 {
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
		if (highHour.truncatingRemainder(dividingBy: 1) == 0) {
			let m = minutes()
			if (m > 30) {
				return Int(highHour) - (h + 1)
			} else {
				return Int(highHour) - h
			}
		} else if highHour.truncatingRemainder(dividingBy: 1) == 0.5 {
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
		if lowHour.truncatingRemainder(dividingBy: 1) == 0.5 {
			if m > 30 {
				h += 1;
			}
		}
//		print("\(h), \(Int(lowHour)), \(lowHour)")
		return h - Int(round(lowHour))
	}
	
	func minutes() -> Int {
		let today:Date
		today = Date.init()
		return Int(minuteFormatter.string(from: today))!
	}
	
	func minutesLeft() -> Int {
		var m:Int = minutes()
		if highHour.truncatingRemainder(dividingBy: 1) == 0.5 {
			if m < 30 {
				m += 30
			}
		}
		if (m != 0) {
			return 59 - m
		}
		else {
			return m
		}
	}
	
	func minutesElapsed() -> Int {
		var m:Int = minutes()
		if lowHour.truncatingRemainder(dividingBy: 1) == 0.5 {
			if m >= 30 {
				m = m - 30
			} else {
				m = 60 + (m - 30)
			}
		}
		return m
	}
	
	func seconds() -> Int {
		let today:Date
		today = Date.init()
		return Int(secondFormatter.string(from: today))!
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
		print("Total: ", total, " Elapsed: ", elapsed);
		return 100.0 * (elapsed / total)
	}
}
