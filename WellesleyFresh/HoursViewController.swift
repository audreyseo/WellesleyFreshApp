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
	var foodEstablishments:[[String]] = [["bplc", "bates", "tower", "stonedavis", "pomeroy"], ["emporium", "collins", "beaker"]]
	var titles:[String] = ["Dining Halls", "Retail Centers"]
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
	
	
	func update() {
		for j in 0...titles.count - 1 {
			for i in 0...foodEstablishments[j].count - 1 {
//				print(i, ":", j)
				let cell = tableView.cellForRow(at: IndexPath(row: i, section: j)) as? ProgressCell
				cell?.mealLabel.text = hours.meal(j, index: i)
				cell?.timeLabel.text = formattedTime(j, index: i)
				cell?.timeLeft.text = formattedTimeLeft(j, index: i)
				cell?.setProgressDouble(hours.percentDone(j, index: i) / 100.0)
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
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return foodEstablishments[section].count
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ProgressCell
		myCell.nameLabel.text = diningHallName[hours.halls[indexPath.section * 5 + indexPath.row]]
		myCell.mealLabel.text = hours.meal(indexPath.section, index: indexPath.row)
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
		return myCell
	}
}
