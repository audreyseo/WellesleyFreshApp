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
	var lowYear = -1
	var highYear = -1
	var dayFormatter:DateFormatter = DateFormatter()
	var yearFormatter:DateFormatter = DateFormatter()
	
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
		super.init(low: lowHour, high: highHour, name: name)
		initFormatters()
		
		let date1:Date = self.get(direction: .Previous, dayNames[lowWeekDay]!, considerToday: true)
		let date2:Date = self.get(direction: .Next, dayNames[highWeekDay]!, considerToday: true)
		
		self.lowDay = getDate(aDate: date1)
		self.highDay = getDate(aDate: date2)
		self.lowYear = getYear(aDate: date1)
		self.highYear = getYear(aDate: date2)
		
//		print(lowDay, lowYear, highDay, highYear)
	}
	
	init( lowHour:Double, highHour:Double, name:String, lowDay:Int, highDay:Int) {
		super.init(low: lowHour, high: highHour, name: name)
		initFormatters()
		
		self.lowDay = lowDay
		self.highDay = highDay
	}
	
	init(lowHour:Double, highHour:Double, name:String, dayChange:Int) {
		super.init(low: lowHour, high: highHour, name: name)
		initFormatters()
		
		
		let today:Date = Date.init()
		self.lowDay = Int(self.dayFormatter.string(from: today))!
		self.highDay = lowDay + dayChange
		self.lowYear = getYear(aDate: today)
		
	}
	
	func initFormatters() {
		yearFormatter = DateFormatter();
		yearFormatter.locale = Locale(identifier: "en_US_POSIX")
		yearFormatter.dateFormat = "yyyy";
		dayFormatter = DateFormatter()
		dayFormatter.locale = Locale(identifier: "en_US_POSIX")
		dayFormatter.dateFormat = "D"
	}
	
	// The following two functions were found on stack overflow, with 
	// some modifications by me so that they're compatible with Swift3
	// http://stackoverflow.com/questions/16809269/how-to-find-out-whether-current-year-leap-year-or-not-in-iphone
	func isYearLeapYear(year:Int) -> Bool {
		return ((( year % 100 != 0) && (year % 4 == 0)) || (year % 400 == 0));
	}
	func isYearLeapYear(aDate:Date) -> Bool {
		let year:Int = self.getYear(aDate: aDate);
		return ((( year % 100 != 0) && (year % 4 == 0)) || (year % 400 == 0));
	}
	
	func getYear(aDate:Date) -> Int {
		let year:Int = Int(yearFormatter.string(from: aDate))!
		return year;
	}
	
	func getLowDay() -> Int {
		return lowDay
//		if self.isYearLeapYear(year: lowYear) {
//			if self.lowDay > 365 {
//				return self.lowDay % 366
//			} else {
//				return self.lowDay
//			}
//		} else {
//			if self.lowDay > 364 {
//				return self.lowDay % 365
//			} else {
//				return self.lowDay
//			}
//		}
	}
	
	func getHigherDay(higherDay:Int) -> Int {
		if self.isYearLeapYear(year: lowYear) {
			if higherDay < self.lowDay {
				return higherDay + 366
			} else {
				return higherDay
			}
		} else {
			if higherDay < self.lowDay {
				return higherDay + 365
			} else {
				return higherDay
			}
		}
	}
	
	func getHighDay() -> Int {
		if self.isYearLeapYear(year: lowYear) {
			if self.highDay < self.lowDay {
				return self.highDay + 366
			} else {
				return self.highDay
			}
		} else {
			if self.highDay < self.lowDay {
				return self.highDay + 365
			} else {
				return self.highDay
			}
		}
	}
	
	override func currentHour() -> Double {
		let today:Date = Date.init()
		let todayDate = getHigherDay(higherDay: getDate(aDate: today))
		let todayHour = Double(getHour(aDate: today))
		var totalHours:Double = 0.0
		
		if todayDate != lowDay {
			totalHours += 24.0 - lowHour
		} else {
			totalHours += todayHour - lowHour
		}
		
		if todayDate == self.getHighDay() {
			totalHours += todayHour
		}
		
		if todayDate > lowDay {
			totalHours += Double(todayDate - lowDay - 1) * 24.0
		}
		
		return totalHours
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
		let dayHours:Double = Double((self.getHighDay() - lowDay) - 1) * 24.0
		let hourHours:Double = (24.0 - lowHour) + highHour
		
		return dayHours + hourHours
	}
	
	override func elapsedTime() -> Double {
		return (currentHour() + (Double(minutesElapsed()) / 60.0) + (Double(secondsElapsed()) / (60.0 * 60.0)))
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
