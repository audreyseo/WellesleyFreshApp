//
//  DiningHours.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 16/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import Foundation


class DiningHours {
	var diningHalls:[String:DiningHall]
	let halls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy"]
	init() {
		
		var firstHours:[[Double]] = [[7, 7.5]]
		firstHours.append([7.5, 10.0])
		firstHours.append([11.5, 14.0])
		firstHours.append([17.0, 19.0])
		var secondHours: [[Double]] = [[8.5, 10.5]]
		secondHours.append([10.5, 14.0])
		secondHours.append([17.0, 18.5])
		let towerHours: [[[Double]]] = [firstHours, secondHours]
		diningHalls = [String : DiningHall]()
		diningHalls["tower"] = DiningHall(newDays: ["MoTuWeThFr", "SaSu"], newHours: towerHours, meals: [["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner"], ["Continental Breakfast", "Hot Brunch", "Dinner"]]);
		diningHalls["bates"] = diningHalls["tower"]
		diningHalls["pomeroy"] = diningHalls["bates"]
		var firstHoursA = [[7, 7.5]]
		firstHoursA.append([7.5, 10.0])
		firstHoursA.append([11.5, 14.0])
		firstHoursA.append([17.0, 20.0])
		firstHoursA.append([20.0, 22.0])
		var secondHoursA = [[7.0, 7.5]]
		secondHoursA.append([7.5, 10.0])
		secondHoursA.append([11.5, 14.0])
		secondHoursA.append([17.0, 20.0])
		let stoneHours = [firstHoursA, secondHoursA]
		diningHalls["stonedavis"] = DiningHall(newDays: ["MoTuWeTh", "Fr"], newHours: stoneHours, meals: [["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner", "Late Night"], ["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner"]])
		var firstHoursB = [[7.0, 10.5]]
		firstHoursB.append([11.5, 14.0])
		firstHoursB.append([17.0, 20.0])
		firstHoursB.append([20.0, 22.0])
		var secondHoursB = [[8.5, 10.5]]
		secondHoursB.append([10.5, 14.0])
		secondHoursB.append([17.0, 20.0])
		secondHoursB.append([20.0, 22.0])
		let luluHours = [firstHoursB, secondHoursB]
		diningHalls["bplc"] = DiningHall(newDays: ["MoTuWeThFr", "SaSu"], newHours: luluHours, meals: [["Continental Breakfast", "Lunch", "Dinner", "Late Night"], ["Continental Breakfast", "Hot Brunch", "Dinner", "Late Night"]])
	}
	
	func isOpen(index:Int) -> Bool {
		if (index < halls.count) {
			return (diningHalls[halls[index]]?.openToday())!
		}
		return false
	}
	
	func meal(index:Int) -> String {
		if (index < halls.count) {
			return (diningHalls[halls[index]]?.currentMeal())!
		}
		return ""
	}
	
	func percentDone(index:Int) -> Double {
		print("Percent left: ", diningHalls[halls[index]]!.percentLeft())
		return (diningHalls[halls[index]]!.percentLeft())
	}
	
	func hoursElapsed(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().hoursElapsed())!
	}
	
	func minsElapsed(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().minutesElapsed())!
	}
	
	func secsElapsed(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().secondsElapsed())!
	}
	
	func hoursLeft(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().hoursLeft())!
	}
	
	func minsLeft(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().minutesLeft())!
	}
	
	func secsLeft(index:Int) -> Int {
		return (diningHalls[halls[index]]?.currentHours().secondsLeft())!
	}
}