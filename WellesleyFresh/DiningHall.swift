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
	
	var meals: [[String]]
	
	init(newDays: [String], newHours: [[[Double]]], meals: [[String]]) {
		self.meals = meals
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
	
	func lastOpenIndex() -> Int {
		let today = days.todaysWeekDate()
		var count:Int = 0
		var yest = yesterday[today]
		
		while count < 7 {
			if days.dayInDayOptions(day: yest!) {
				return days.getOptionForDay(day: yest!)
			} else {
				yest = yesterday[yest!]
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
		let lastOpenIndex = self.lastOpenIndex() //days.getOption()
		let nextOpenIndex = self.nextOpenIndex()
		var endHour:Double = -1.0
		var beginHour:Double = -1.0
		
		if nextOpenIndex >= 0 {
			endHour = hours[nextOpenIndex][0].lowHour
		}
		
		if lastOpenIndex >= 0 {
			beginHour = hours[lastOpenIndex][hours[lastOpenIndex].count - 1].highHour
		}
		
		
		let firstDay:String = whenLastOpen()
		let nextDay:String = whenNextOpen()
		print("lastDay: \(nextDay), firstDay: \(firstDay)")
		
		if nextDay != "" && firstDay != "" {
			whenClosed = DayHourRange(lowHour: beginHour, highHour: endHour, name: "Closed", lowWeekDay: firstDay, highWeekDay: nextDay)
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
	
	func isInBetween(_ a: HourRange, b: HourRange) -> Bool {
		let btwn = a.inBetween(other: b)
		return btwn.withinRange()
	}
	
	func inBetween(_ a:HourRange, b:HourRange) {
		let currentTime = a.currentHour()
		if currentTime >= a.highHour && currentTime <= b.lowHour {
			in_between = HourRange(low: a.highHour, high: b.lowHour, name: "Next: \(b.name())")
		}
	}
	
	func nextName(option: Int) -> String {
		if option < hours.count && option >= 0 {
			print("Option: \(option), Hours.count: \(hours.count)")
			for i in 1..<hours[option].count {
				if hours[option][i - 1].hasAlreadyHappened() {
					if hours[option][i].hasNotHappened() || hours[option][i].withinRange() {
						return hours[option][i].name()
					}
				}
			}
		}
		return ""
	}
	
	func nextName() -> String {
		return nextName(option: self.days.getOption())
	}
	
	func todaysMeals() -> [String] {
		return self.meals[self.days.getOption()]
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
		return whenClosed.percentTimeElapsed()
	}
}
