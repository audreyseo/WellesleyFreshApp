//
//  DiningHall.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class DiningHall {
	var hours:[[HourRange]]
	var days:DayOptions
	var in_between:HourRange
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
	}
	
	func openToday() -> Bool {
		return days.hasToday()
	}
	
	func closed() -> Bool {
		return !days.hasToday()
	}
	
	func currentMeal() -> String {
		return currentHours().name()
	}
	
	func inBetween(a:HourRange, b:HourRange) {
		let currentTime = a.currentHour()
//		print("In-Between?: \(currentTime), (\(a.lowHour), \(a.highHour)), (\(b.lowHour), \(b.highHour))")
		if currentTime >= a.highHour && currentTime <= b.lowHour {
			in_between = HourRange(low: a.highHour, high: b.lowHour, name: "Closed, Next: \(b.name())")
		}
	}
	
	func currentHours() -> HourRange {
		if (self.openToday()) {
			let option = self.days.getOption()
			if (!in_between.withinRange()) {
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
			} else {
				return in_between
			}
			
		}
		return HourRange(low: 0, high: 0, name: "Closed")
	}
	
	func percentLeft() -> Double {
		print("Are we open today?: ", self.openToday())
		if self.openToday() {
			print("Hi.")
			let option = self.days.getOption()
			
			if !in_between.withinRange() {
				for i in 0...hours[option].count - 1 {
					if hours[option][i].withinRange() {
						print("If happened")
						return hours[option][i].percentTimeElapsed()
					}
				}
			} else {
				print("Else happened");
				return in_between.percentTimeElapsed()
			}
			
		} else {
			print("Other hi")
			return 0
		}
		return 0.0
	}
}