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
		var towerHours: [[[Double]]] = [firstHours, secondHours]
		diningHalls = [String : DiningHall]()
		diningHalls["tower"] = DiningHall(newDays: ["MoTuWeThFr", "SaSu"], newHours: towerHours, meals: [["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner"], ["Continental Breakfast", "Hot Brunch", "Dinner"]]);
		diningHalls["bates"] = diningHalls["tower"]
		diningHalls["pomeroy"] = diningHalls["bates"]
		firstHours = [[7, 7.5]]
		firstHours.append([7.5, 10.0])
		firstHours.append([11.5, 14.0])
		firstHours.append([17.0, 20.0])
		firstHours.append([20.0, 22.0])
		secondHours = [[7.0, 7.5]]
		secondHours.append([7.5, 10.0])
		secondHours.append([11.5, 14.0])
		secondHours.append([17.0, 20.0])
		towerHours = [firstHours, secondHours]
		diningHalls["stonedavis"] = DiningHall(newDays: ["MoTuWeTh", "Fr"], newHours: towerHours, meals: [["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner", "Late Night"], ["Continental Breakfast", "Full Breakfast", "Lunch", "Dinner"]])
		firstHours = [[7.0, 10.5]]
		firstHours.append([11.5, 14.0])
		firstHours.append([17.0, 20.0])
		firstHours.append([20.0, 22.0])
		secondHours = [[8.5, 10.5]]
		secondHours.append([10.5, 14.0])
		secondHours.append([17.0, 20.0])
		secondHours.append([20.0, 22.0])
		towerHours = [firstHours, secondHours]
		diningHalls["bplc"] = DiningHall(newDays: ["MoTuWeThFr", "SaSu"], newHours: towerHours, meals: [["Continental Breakfast", "Lunch", "Dinner", "Late Night"], ["Continental Breakfast", "Hot Brunch", "Dinner", "Late Night"]])
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
		return (diningHalls[halls[index]]?.percentLeft())!
	}
}