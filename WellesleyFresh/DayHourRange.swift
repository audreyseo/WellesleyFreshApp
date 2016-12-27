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
	
	var dayNames:[String:String] = [
		"Mo": "Monday",
		"Tu": "Tuesday",
		"We": "Wednesday",
		"Th": "Thursday",
		"Fr": "Friday",
		"Sa": "Saturday",
		"Su": "Sunday"
	]
	
	init( lowHour:Double, highHour:Double, name:String, lowWeekDay:String, highWeekDay:String) {
		dayFormatter = DateFormatter()
		dayFormatter.locale = Locale(identifier: "en_US_POSIX")
		dayFormatter.dateFormat = "d"
		super.init(low: lowHour, high: highHour, name: name)
		
		let date1:Date = self.get(direction: .Previous, dayNames[lowWeekDay]!, considerToday: true)
		let date2:Date = self.get(direction: .Next, dayNames[highWeekDay]!, considerToday: true)
		
		self.lowDay = getDate(aDate: date1)
		self.highDay = getDate(aDate: date2)
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
	
	init( lowHour:Double, highHour:Double, name:String, lowDay:Int, highDay:Int) {
		dayFormatter = DateFormatter()
		dayFormatter.locale = Locale(identifier: "en_US_POSIX")
		dayFormatter.dateFormat = "d"
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
		dayFormatter = DateFormatter()
		dayFormatter.locale = Locale(identifier: "en_US_POSIX")
		dayFormatter.dateFormat = "d"
		super.init(low: lowHour, high: highHour, name: name)
		
		
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
		let todayHour = Double(getHour(aDate: today))
		var totalHours:Double = 0.0
		
		if todayDate != lowDay {
			totalHours += 24.0 - lowHour
		} else {
			totalHours += todayHour - lowHour
		}
		
		if todayDate == highDay {
			totalHours += todayHour
		}
		
		if todayDate > lowDay {
			totalHours += Double(todayDate - lowDay - 1) * 24.0
		}
		
		return totalHours
		
		//var diff:Double = Double(todayDate - lowDay)
		
		//if diff > 0 {
		//	totalHours += (24 - lowHour)
		//	diff -= 1.0
		//	let diff1 = highDay - todayDate
		//	if diff1 == 0 {
		//		diff -= 1.0
		//		return totalHours + Double(todayHour) + (diff * 24.0)
		//	}
		//	return totalHours + Double(todayHour)
		//} else {
		//	return Double(todayHour) - lowHour
		//}
	}
	
	override func highMinutes() -> Double {
		return totalChange() * 60.0
	}
	
	override func onlyMinutes() -> Double {
		return (currentHour() * 60.0) + Double(minutes())
	}
	
	override func hoursLeft() -> Int {
		let secondsDiff = Int(ceil(Double((60 - seconds()) % 60) / 60.0))
		return Int(floor(((totalChange() * 60 - currentHour() * 60) - Double(secondsDiff)) / 60))
	}
	
	override func minutesLeft() -> Int {
		return max(((Int(highMinutes() - onlyMinutes()) - Int(ceil(Double((60 - seconds()) % 60) / 60.0))) % 60), 0)
	}
	
	override func minutesElapsed() -> Int {
		return minutes()
	}
	
	override func hoursElapsed() -> Int {
		return Int(currentHour())
	}
	
	override func totalChange() -> Double {
		let dayHours:Double = Double((highDay - lowDay) - 1) * 24.0
		let hourHours:Double = (24.0 - lowHour) + highHour
		
//		print("Total change: ", dayHours + hourHours)
//		print("High: ", highHour, " low: ", lowHour)
		return dayHours + hourHours
	}
	
	override func elapsedTime() -> Double {
		return currentHour()
	}
	
	
	func getDate(aDate:Date) -> Int {
		return Int(dayFormatter.string(from: aDate))!
	}
	
	
	// I found the following functions and enum on stackoverflow, by Sandeep http://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift
	
	func getWeekDaysInEnglish() -> [String] {
		let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
		return calendar.weekdaySymbols
	}
	
	enum SearchDirection {
		case Next
		case Previous
		
		var calendarOptions: NSCalendar.Options {
			switch self {
			case .Next:
				return .matchNextTime
			case .Previous:
				return [.searchBackwards, .matchNextTime]
			}
		}
	}
	
	func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> Date {
		let weekdaysName = getWeekDaysInEnglish()
		
		assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
		
		let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
		
		let today = Date()
		
		let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		
		if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
			return today
		}
		
		let nextDateComponent = NSDateComponents()
		nextDateComponent.weekday = nextWeekDayIndex
		
		
		let date = calendar.nextDate(after: today as Date, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
		return date!
	}
}
