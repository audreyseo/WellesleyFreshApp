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
	init(newDays: [String], newHours: [[[Double]]], meals: [[String]]) {
		hours = [[HourRange]]()
		for i in 0...newHours.count - 1 {
			hours.append([HourRange]())
			for j in 0...newHours[i].count - 1 {
				hours[i].append(HourRange(low: newHours[i][j][0], high: newHours[i][j][1], name: meals[i][j]))
			}
		}
		days = DayOptions(initialDays: newDays)
	}
	
	func openToday() -> Bool {
		return days.hasToday()
	}
	
	func closed() -> Bool {
		return !days.hasToday()
	}
	
	func currentMeal() -> String {
		if (self.openToday()) {
			let option = self.days.getOption()
			
			for i in 0...hours.count - 1 {
				if hours[option][i].withinRange() {
					return hours[option][i].name()
				}
			}
		}
		return "Closed"
	}
	
	func percentLeft() -> Double {
		if (self.openToday()) {
			let option = self.days.getOption()
			
			for i in 0...hours.count - 1 {
				if hours[option][i].withinRange() {
					return hours[option][i].percentTimeElapsed()
				}
			}
		}
		return 0
	}
}