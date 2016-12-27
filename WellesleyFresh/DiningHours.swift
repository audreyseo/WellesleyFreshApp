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
	let halls:[String] = ["bplc", "bates", "tower", "stonedavis", "pomeroy", "emporium", "collins", "beaker"]
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
		var firstHoursA:[[Double]] = [[7, 7.5]]
		firstHoursA.append([7.5, 10.0])
		firstHoursA.append([11.5, 14.0])
		firstHoursA.append([17.0, 20.0])
		firstHoursA.append([20.0, 22.0])
		var secondHoursA:[[Double]] = [[7.0, 7.5]]
		secondHoursA.append([7.5, 10.0])
		secondHoursA.append([11.5, 14.0])
		secondHoursA.append([17.0, 19.0])
		let stoneHours:[[[Double]]] = [firstHoursA, secondHoursA]
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
		
		let emporiumHours = [[[7.0, 20.0]], [[7.0, 24.0]], [[12.0, 20.0]]]
		diningHalls["emporium"] = DiningHall(newDays: ["MoFr", "TuWeTh", "SaSu"], newHours: emporiumHours, meals: [["Open"], ["Open"], ["Open"]])
		
		let collinsHours = [[[8.0, 14.0]]]
		diningHalls["collins"] = DiningHall(newDays: ["MoTuWeThFr"], newHours: collinsHours, meals: [["Open"]])
		
		let beakerHours = [[[8.0, 16.0]]]
		diningHalls["beaker"] = DiningHall(newDays: ["MoTuWeThFr"], newHours: beakerHours, meals: [["Open"]])
	}
	
	func isOpen(_ section:Int, index: Int) -> Bool {
		if (index < halls.count && (section * 5) + index < halls.count) {
			return (diningHalls[halls[(section * 5) + index]]?.openToday())!
		}
		return false
	}
	
	func isOpen(_ index:Int) -> Bool {
		if (index < halls.count) {
			return (diningHalls[halls[index]]?.openToday())!
		}
		return false
	}
	
	func meal(_ section:Int, index:Int) -> String {
		if (index + (section * 5) < halls.count) {
			return (diningHalls[halls[(section * 5) + index]]?.currentMeal())!
		}
		return ""
	}
	
	func meal(_ index:Int) -> String {
		if (index < halls.count) {
			return (diningHalls[halls[index]]?.currentMeal())!
		}
		return ""
	}
	
	func percentDone(_ section:Int, index:Int) -> Double {
		//		print("Percent left: ", diningHalls[halls[index]]!.percentLeft())
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index + section * 5]]?.closedHours().percentTimeElapsed())!
		}
		return (diningHalls[halls[(section * 5) + index]]!.percentLeft())
	}
	
	func hoursElapsed(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index + section * 5]]?.closedHours().hoursElapsed())!
		}
		return (diningHalls[halls[(section * 5) + index]]?.currentHours().hoursElapsed())!
	}
	
	
	func minsElapsed(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index + section * 5]]?.closedHours().minutesElapsed())!
		}
		return (diningHalls[halls[(section * 5) + index]]?.currentHours().minutesElapsed())!
	}
	
	func secsElapsed(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index + section * 5]]?.closedHours().secondsElapsed())!
		}
		return (diningHalls[halls[(section * 5) + index]]?.currentHours().secondsElapsed())!
	}
	
	func hoursLeft(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index + section * 5]]?.closedHours().hoursLeft())!
		}
		return (diningHalls[halls[(section * 5) + index]]?.currentHours().hoursLeft())!
	}
	
	func minsLeft(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[(section * 5) + index]]?.closedHours().minutesLeft())!
		}
		return (diningHalls[halls[index + section * 5]]?.currentHours().minutesLeft())!
	}
	
	func secsLeft(_ section:Int, index:Int) -> Int {
		if (diningHalls[halls[(section * 5) + index]]?.isClosed())! {
			return (self.diningHalls[self.halls[(section * 5) + index]]?.closedHours().secondsLeft())!
		}
		return (diningHalls[halls[(section * 5) + index]]?.currentHours().secondsLeft())!
	}
	
	func percentDone(_ index:Int) -> Double {
//		print("Percent left: ", diningHalls[halls[index]]!.percentLeft())
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().percentTimeElapsed())!
		}
		return (diningHalls[halls[index]]!.percentLeft())
	}
	
	func hoursElapsed(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().hoursElapsed())!
		}
		return (diningHalls[halls[index]]?.currentHours().hoursElapsed())!
	}
	
	
	func minsElapsed(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().minutesElapsed())!
		}
		return (diningHalls[halls[index]]?.currentHours().minutesElapsed())!
	}
	
	func secsElapsed(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().secondsElapsed())!
		}
		return (diningHalls[halls[index]]?.currentHours().secondsElapsed())!
	}
	
	func hoursLeft(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().hoursLeft())!
		}
		return (diningHalls[halls[index]]?.currentHours().hoursLeft())!
	}
	
	func minsLeft(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().minutesLeft())!
		}
		return (diningHalls[halls[index]]?.currentHours().minutesLeft())!
	}
	
	func secsLeft(_ index:Int) -> Int {
		if (diningHalls[halls[index]]?.isClosed())! {
			return (self.diningHalls[self.halls[index]]?.closedHours().secondsLeft())!
		}
		return (diningHalls[halls[index]]?.currentHours().secondsLeft())!
	}
}
