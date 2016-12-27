//
//  DiningHall.swift
//  WellesleyFresh
//	
//	Represents a dining halls' operating hours and times.
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit


class DiningHall {
	var hours:[[HourRange]]
	var days:DayOptions
	var in_between:HourRange
	var whenClosed:DayHourRange
	let nextDay:[String:String] = [
		"Su":"Mo", "Mo":"Tu", "Tu":"We", "We":"Th", "Th":"Fr", "Fr":"Sa", "Sa": "Su"
	]
	let yesterday:[String:String] = [
		"Su":"Sa", "Sa":"Fr", "Fr":"Th", "Th":"We", "We":"Tu", "Tu":"Mo", "Mo":"Su"
	]
	
	init(newDays: [String], newHours: [[[Double]]], meals: [[String]]) {
		hours = [[HourRange]]()
		for i in 0...newHours.count - 1 {
			hours.append([HourRange]())
			for j in 0...newHours[i].count - 1 {
				hours[i].append(HourRange(low: newHours[i][j][0], high: newHours[i][j][1], name: meals[i][j]))
			}
		}
		days = DayOptions(initialDays: newDays)
		in_between = HourRange(low: 0, high: 0, name: "Closed")
		whenClosed = DayHourRange(lowHour: 0.0, highHour: 0.0, name: "Closed", lowDay: 0, highDay: 0)
	}
	
	func openToday() -> Bool {
		return days.hasToday()
	}
	
	func nextOpenIndex() -> Int {
		let today = days.todaysWeekDate()
		var count:Int = 0
		//if openToday() && hours[0][0].hours() < 12 {
		//	return days.getOptionForDay(day: today)
		//}
		var next = nextDay[today]
		
		while count < 7 {
			
			if days.dayInDayOptions(day: next!) {
				return days.getOptionForDay(day: next!)
			} else {
				next = nextDay[next!]
				count += 1
			}
		}
		
		return -1
	}
	
	func whenNextOpen() -> String {
		let today = days.todaysWeekDate()
		var count:Int = 0
		var next = nextDay[today]
		count += 1
		while count < 7 {
			if days.dayInDayOptions(day: next!) {
				return next!
			} else {
				next = nextDay[next!]
				count += 1
			}
		}
		
		return ""
	}
	
	func whenLastOpen() -> String {
		let today = days.todaysWeekDate()
		if openToday() && hours[0][0].hours() >= 12 {
			return today
		}
		var count:Int = 0
		var yester = yesterday[today]
		count += 1
		while count < 7 {
			if days.dayInDayOptions(day: yester!) {
				return yester!
			} else {
				yester = yesterday[yester!]
				count += 1
			}
		}
		
		return ""
	}
	
	func nextOpenInterval() {
		let lastOpenIndex = days.getOption()
		let nextOpenIndex = self.nextOpenIndex()
		var endHour:Double = -1.0
		var beginHour:Double = -1.0
		
		if nextOpenIndex >= 0 {
			endHour = hours[nextOpenIndex][0].lowHour
//			for i in 0...hours[nextOpenIndex].count - 1 {
//				print("#", i, " : ", hours[nextOpenIndex][i].lowHour)
//			}
		}
		
		if lastOpenIndex >= 0 {
			beginHour = hours[lastOpenIndex][hours[lastOpenIndex].count - 1].highHour
		}
		
		let lastDay:String = whenNextOpen()
		let firstDay:String = whenLastOpen()
		
		if lastDay != "" && firstDay != "" {
			whenClosed = DayHourRange(lowHour: beginHour, highHour: endHour, name: "Closed", lowWeekDay: firstDay, highWeekDay: lastDay)
		}
	}
	
	func closed() -> Bool {
		return !days.hasToday()
	}
	
	func isClosed() -> Bool {
		return currentHours().name().contains("Closed")
	}
	
	func currentMeal() -> String {
		return currentHours().name()
	}
	
	func inBetween(_ a:HourRange, b:HourRange) {
		let currentTime = a.currentHour()
//		print("In-Between?: \(currentTime), (\(a.lowHour), \(a.highHour)), (\(b.lowHour), \(b.highHour))")
		if currentTime >= a.highHour && currentTime <= b.lowHour {
			in_between = HourRange(low: a.highHour, high: b.lowHour, name: "Next: \(b.name())")
		}
	}
	
	func findRange(option:Int) -> HourRange {
		for i in 0...hours[option].count - 1 {
			if hours[option][i].withinRange() {
				return hours[option][i]
			}
			if i < hours[option].count - 1 {
				inBetween(hours[option][i], b: hours[option][i + 1])
				if in_between.withinRange() {
					return in_between
				}
			}
		}
		return HourRange(low: 0, high: 0, name: "Closed")
	}
	
	func currentHours() -> HourRange {
		if (self.openToday()) {
			let option = self.days.getOption()
			if (in_between.hasARange()) {
				if (!in_between.withinRange()) {
					return findRange(option: option)
				} else {
					return in_between
				}
			} else {
				return findRange(option: option)
			}
		}
		return HourRange(low: 0, high: 0, name: "Closed")
	}
	
	func closedHours() -> DayHourRange {
		if !whenClosed.hasARange() && !whenClosed.withinRange() {
			nextOpenInterval()
		}
		return whenClosed
	}
	
	func percentLeft() -> Double {
		let current = currentHours()
		if (current.name() != "Closed") {
			return currentHours().percentTimeElapsed()
		}
		if !whenClosed.hasARange() && !whenClosed.withinRange() {
			nextOpenInterval()
			print("When Closed Percent Time Elapsed: ", whenClosed.percentTimeElapsed())
			print("Current Hours:                    ", whenClosed.currentHour())
			print("Hours to go:                      ", whenClosed.totalChange() - whenClosed.currentHour())
		}
		
		
		//print("WHen Closed Beginnings: ", whenClosed.lowDay, ", ",  whenClosed.lowHour)
		//print("When Closed Endings: ", whenClosed.highDay, ", ", whenClosed.highHour)
		return whenClosed.percentTimeElapsed()
		//		print("Are we open today?: ", self.openToday())
//		if self.openToday() {
//			print("Hi.")
//			let option = self.days.getOption()
		
//			if !in_between.hasARange() {
//				for i in 0...hours[option].count - 1 {
//					if hours[option][i].withinRange() {
//						print("If happened")
//						return hours[option][i].percentTimeElapsed()
//					}
//				}
//			} else {
//				print("Else happened");
//				return in_between.percentTimeElapsed()
//			}
		
//		} else {
//			print("Other hi")
//			return 0
//		}
		
	}
}
