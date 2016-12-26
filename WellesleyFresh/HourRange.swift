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
	
	func currentMinutes() -> Double {
		let today:Date = Date.init()
		let h:Int = Int(hourFormatter.string(from: today))!
		let m:Int = Int(minuteFormatter.string(from: today))!
		let hour:Double = Double(h)
		let minute:Double = Double(m)
		return (hour * 60.0) + minute
	}
	
	func currentSeconds() -> Double {
		let minutes = currentMinutes()
		let today:Date = Date.init()
		let s:Int = Int(secondFormatter.string(from: today))!
		let second:Double = Double(s)
		return second + (minutes * 60.0)
	}
	
	func lowMinutes() -> Double {
		return lowHour * 60.0
	}

	
	func highMinutes() -> Double {
		return highHour * 60.0
	}
	
	func lowSeconds() -> Double {
		return lowMinutes() * 60.0
	}
	
	func highSeconds() -> Double {
		return highMinutes() * 60.0
	}
	
	func onlyMinutes() -> Double {
		return Double((hours() * 60) + minutes())
	}

	
	
	
	
	func hours() -> Int {
		let today:Date
		today = Date.init()
		return Int(hourFormatter.string(from: today))!
	}
	
	func hoursLeft() -> Int {
//		var h:Int = onlyMinutes()
		return Int(floor((highMinutes() - onlyMinutes()) / 60))
//		print("\(h), \(Int(highHour)), \(highHour)")
//		if (highHour == 0) {
//			if lowHour.truncatingRemainder(dividingBy: 1.0) == 0.5 {
//				let m = minutes()
//				if (m > 30) {
//					return 24 - (h + 1)
//				} else {
//					return 24 - h
//				}
//			} else {
//				return 24 - h
//			}
//		}
//		if (highHour.truncatingRemainder(dividingBy: 1) == 0) {
//			let m = minutes()
//			if (m > 30) {
//				return Int(highHour) - (h + 1)
//			} else {
//				return Int(highHour) - h
//			}
//		} else if highHour.truncatingRemainder(dividingBy: 1) == 0.5 {
//			let m = minutes()
//			if m <= 30 {
//				h += 1
//			}
//			return Int(highHour) - h
//		}
//		return Int(highHour) - h
	}
	
	func hoursElapsed() -> Int {
		let dif = onlyMinutes() - lowMinutes()
		return Int(floor(dif / 60))
//		var h:Int = hours()
//		let m:Int = minutes()
//		if lowHour.truncatingRemainder(dividingBy: 1) == 0.5 {
//			if m > 30 {
//				h += 1;
//			}
//		}
//		print("\(h), \(Int(lowHour)), \(lowHour)")
//		return h - Int(round(lowHour))
	}
	
	func minutes() -> Int {
		let today:Date
		today = Date.init()
		return Int(minuteFormatter.string(from: today))!
	}
	
	func minutesLeft() -> Int {
		return (Int(highMinutes() - onlyMinutes()) % 60) - Int(ceil(Double((60 - seconds()) % 60) / 60.0))
//		var m:Int = minutes()
//		if highHour.truncatingRemainder(dividingBy: 1) == 0.5 {
//			if m < 30 {
//				m += 30
//			}
//		}
//		if (m != 0) {
//			return 59 - m
//		}
//		else {
//			return m
//		}
	}
	
	func minutesElapsed() -> Int {
		return Int(onlyMinutes() - lowMinutes()) % 60
//		var m:Int = minutes()
//		if lowHour.truncatingRemainder(dividingBy: 1) == 0.5 {
//			if m >= 30 {
//				m = m - 30
//			} else {
//				m = 60 + (m - 30)
//			}
//		}
//		return m
	}
	
	func seconds() -> Int {
		let today:Date
		today = Date.init()
		return Int(secondFormatter.string(from: today))!
	}
	
	func secondsLeft() -> Int {
		return (60 - seconds()) % 60
	}
	
	func secondsElapsed() -> Int {
		return seconds()
	}
	
	func withinRange() -> Bool {
		let hour:Double = currentHour()
		if hour < highHour && hour >= lowHour {
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
//		print("Total: ", total, " Elapsed: ", elapsed);
		return 100.0 * (elapsed / total)
	}
	
	func hasARange() -> Bool {
		if highHour - lowHour > 0 {
			return true
		}
		return false
	}
}
