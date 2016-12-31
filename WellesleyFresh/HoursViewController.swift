//
//  HoursViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class HoursViewController: UITableViewController {
	var hours:DiningHours = DiningHours()
	var diningHallName:[String:String] = ["stonedavis":"Stone Davis", "bates":"Bates", "bplc":"Lulu", "tower":"Tower", "pomeroy":"Pomeroy", "emporium": "Emporium", "collins": "Collins Cafe", "beaker": "Leaky Beaker"]
	var foodEstablishments:[[String]] = [["bplc", "bates", "tower", "stonedavis", "pomeroy"], ["emporium", "collins", "beaker"], []]
	var titles:[String] = ["Dining Halls", "Retail Centers", ""]
	var timer: Timer = Timer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.sectionHeaderHeight = 40
		
		navigationItem.title = "Hours of Operation"
		
		// Assigns the class MyCell to the type of cell that we use in the table view
		tableView.register(ProgressCell.self, forCellReuseIdentifier: "cellId")
		tableView.register(GroupHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
		tableView.delegate = self
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HoursViewController.update), userInfo: nil, repeats: true)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		let footerView = GroupHeader(reuseIdentifier: "headerId")
		footerView.nameLabel.text = ""
		footerView.isOpaque = true
		
		// Need to delete either one of these but all I wanted is for the background to be normal hallelujah
		self.tableView.backgroundColor = UIColor.groupTableViewBackground
		self.view.backgroundColor = UIColor.groupTableViewBackground
		self.tableView.tableFooterView = footerView
		self.tableView.tableFooterView?.tintColor = UIColor.groupTableViewBackground
	}
	
	
	func update() {
		for j in 0..<titles.count {
			for i in 0..<foodEstablishments[j].count {
//				print(i, ":", j)
				let cell = tableView.cellForRow(at: IndexPath(row: i, section: j)) as? ProgressCell
				let meal:String = hours.meal(j, index: i)
				cell?.setMealLabel(label: meal)
//				cell?.mealLabel.text = meal
				cell?.timeLabel.text = formattedTime(j, index: i)
				cell?.timeLeft.text = formattedTimeLeft(j, index: i)
				cell?.setProgressDouble(hours.percentDone(j, index: i) / 100.0)
				cell?.progress.progressViewStyle = .default
				cell?.progress.layer.cornerRadius = 3.0
//				cell?.progress.pr
//				if meal.contains("Closed") {
//					cell?.progress.progressTintColor = UIColor.red
//				} else if meal.contains("Next") {
//					cell?.progress.progressTintColor = UIColor.orange
//				} else {
//					cell?.progress.progressTintColor = UIColor.blue
//				}
			}
		}
	}
	
	func formattedTime(_ section:Int, index: Int) -> String {
		let seconds = hours.secsElapsed(section, index: index)
		let minutes = hours.minsElapsed(section, index: index)
		var secondsZero = ""
		var minutesZero = ""
		if seconds < 10 {
			secondsZero = "0"
		}
		if minutes < 10 {
			minutesZero = "0"
		}
		return "\(hours.hoursElapsed(section, index: index)):\(minutesZero)\(minutes):\(secondsZero)\(seconds)"
	}
	
	func formattedTimeLeft(_ section:Int, index: Int) -> String {
		let seconds = hours.secsLeft(section, index: index)
		let minutes = hours.minsLeft(section, index: index)
		let h = hours.hoursLeft(section, index: index)
		var secondsZero = ""
		var minutesZero = ""
		if seconds < 10 {
			secondsZero = "0"
		}
		if minutes < 10 {
			minutesZero = "0"
		}
		return "\(h):\(minutesZero)\(minutes):\(secondsZero)\(seconds)"
	}
	
	func formattedTime(_ index: Int) -> String {
		let seconds = hours.secsElapsed(index)
		let minutes = hours.minsElapsed(index)
		var secondsZero = ""
		var minutesZero = ""
		if seconds < 10 {
			secondsZero = "0"
		}
		if minutes < 10 {
			minutesZero = "0"
		}
		return "\(hours.hoursElapsed(index)):\(minutesZero)\(minutes):\(secondsZero)\(seconds)"
	}
	
	func formattedTimeLeft(_ index: Int) -> String {
		let seconds = hours.secsLeft(index)
		let minutes = hours.minsLeft(index)
		let h = hours.hoursLeft(index)
		var secondsZero = ""
		var minutesZero = ""
		if seconds < 10 {
			secondsZero = "0"
		}
		if minutes < 10 {
			minutesZero = "0"
		}
		return "\(h):\(minutesZero)\(minutes):\(secondsZero)\(seconds)"
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return foodEstablishments[section].count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ProgressCell
		myCell.nameLabel.text = diningHallName[hours.halls[indexPath.section * 5 + indexPath.row]]
		let meal:String = hours.meal(indexPath.section, index: indexPath.row)
		myCell.setMealLabel(label: meal)
//		myCell.mealLabel.text = meal
//		if meal.contains("Closed") {
//			myCell.progress.progressTintColor = UIColor.red
//		} else if meal.contains("Next") {
//			myCell.progress.progressTintColor = UIColor.orange
//		} else {
//			myCell.progress.progressTintColor = UIColor.blue
//		}
		myCell.timeLabel.text = formattedTime(indexPath.section, index: indexPath.row)
		myCell.timeLeft.text = formattedTimeLeft(indexPath.section, index: indexPath.row)
		myCell.setProgressDouble(hours.percentDone(indexPath.section, index: indexPath.row) / 100.0)
		//		myCell.myTableViewController = self
		return myCell
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titles[section]
	}

	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return titles.count
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! GroupHeader
		myCell.contentView.backgroundColor = UIColor.groupTableViewBackground
		return myCell
	}
}
