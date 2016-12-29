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
		
		// Use 24-hour time
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
	
	func getHour(aDate:Date) -> Int {
		return Int(hourFormatter.string(from: aDate))!
	}
	
	func getMinute(aDate:Date) -> Int {
		return Int(minuteFormatter.string(from: aDate))!
	}
	
	func getSecond(aDate:Date) -> Int {
		return Int(secondFormatter.string(from: aDate))!
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
		let secondsDiff = Int(ceil(Double((60 - seconds()) % 60) / 60.0))
		return Int(floor((highMinutes() - onlyMinutes() - Double(secondsDiff)) / 60))
	}
	
	func hoursElapsed() -> Int {
		let dif = onlyMinutes() - lowMinutes()
		let hoursPlain = Int(floor(dif / 60))
		return hoursPlain
	}
	
	func minutes() -> Int {
		let today:Date
		today = Date.init()
		return Int(minuteFormatter.string(from: today))!
	}
	
	func minutesLeft() -> Int {
		return max(((Int(highMinutes() - onlyMinutes()) - Int(ceil(Double((60 - seconds()) % 60) / 60.0))) % 60), 0)
	}
	
	func minutesElapsed() -> Int {
		return Int(onlyMinutes() - lowMinutes()) % 60
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
	
	func totalChange() -> Double {
		return highHour - lowHour
	}
	
	func elapsedTime() -> Double {
		return currentHour() - lowHour
	}
	
	func percentTimeElapsed() -> Double {
		let total = totalChange()
		let elapsed = elapsedTime()
		return 100.0 * (elapsed / total)
	}
	
	func hasARange() -> Bool {
		if totalChange() > 0 {
			return true
		}
		return false
	}
}
