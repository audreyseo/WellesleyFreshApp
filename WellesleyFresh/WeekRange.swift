//
//  WeekRange.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 20/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import Foundation


class WeekRange {
	var startDate: Date!
	var stopDate: Date!
	var dateRange: String!
	
	init() {
		startDate = self.get(direction: .Previous, "Sunday", considerToday: true)
		stopDate = self.get(direction: .Next, "Saturday", considerToday: true)
		
		let df = DateFormatter()
		df.locale = Locale(identifier: "en_US_POSIX")
		df.dateFormat = "YYYY-MM-dd"
		
//		startDate = date1
//		stopDate = date2
		dateRange = "\(df.string(from: startDate))|\(df.string(from: stopDate)))"
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
