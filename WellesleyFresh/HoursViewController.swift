//
//  HoursViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class HoursViewController: UITableViewController {
	var hours = DiningHours()
	var timer: NSTimer = NSTimer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.sectionHeaderHeight = 40
		
		navigationItem.title = "Hours of Operation"
		
//		let button = UIBarButtonItem(title: "Update", style: .Plain, target: self, action: #selector(HoursViewController.update))
		
//		navigationItem.rightBarButtonItem = button
		
		// Assigns the class MyCell to the type of cell that we use in the table view
		tableView.registerClass(ProgressCell.self, forCellReuseIdentifier: "cellId")
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HoursViewController.update), userInfo: nil, repeats: true)
	}
	
	
	func update() {
		for i in 0...4 {
			let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ProgressCell
			cell.timeLabel.text = formattedTime(i)
			cell.timeLeft.text = formattedTimeLeft(i)
			cell.setProgressDouble(hours.percentDone(i) / 100.0)
		}
	}
	
	func formattedTime(index: Int) -> String {
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
	
	func formattedTimeLeft(index: Int) -> String {
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
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! ProgressCell
		myCell.nameLabel.text = hours.halls[indexPath.row]
		myCell.mealLabel.text = hours.meal(indexPath.row)
		myCell.timeLabel.text = formattedTime(indexPath.row)
		myCell.timeLeft.text = formattedTimeLeft(indexPath.row)
		myCell.setProgressDouble(hours.percentDone(indexPath.row) / 100.0)
		//		myCell.myTableViewController = self
		return myCell
	}
}
