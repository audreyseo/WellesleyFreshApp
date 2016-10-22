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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.sectionHeaderHeight = 40
		
		navigationItem.title = "Hours of Operation"
		
		// Assigns the class MyCell to the type of cell that we use in the table view
		tableView.registerClass(MyCell.self, forCellReuseIdentifier: "cellId")
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let myCell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! MyCell
		myCell.nameLabel.text = hours.halls[indexPath.row]
		//		myCell.myTableViewController = self
		return myCell
	}
}
