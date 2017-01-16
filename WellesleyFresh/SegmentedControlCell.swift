//
//  SegmentedControlCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 26/12/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit


class SegmentedControlCell: MyCell {
	var myTableViewController: SettingsViewController?
	var storedData:UserDefaults = UserDefaults()
	var segmentItems:[String] = [""]
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let control: UISegmentedControl = {
		let c = UISegmentedControl(items: ["Hi", "Hi"])
		c.translatesAutoresizingMaskIntoConstraints = false
		return c
	}()
	
	func setupSegmentedControl(items: [String]) {
		self.segmentItems = items
		control.removeAllSegments()
		for i in 0...items.count - 1 {
			control.insertSegment(withTitle: items[i], at: i, animated: false)
			if items[i].hasPrefix(getLastSelection()) {
				control.selectedSegmentIndex = i
			}
		}
	}
	
	func getLastSelection() -> String {
		if storedData.object(forKey: nameLabel.text!) != nil {
			return storedData.object(forKey: nameLabel.text!) as! String
		} else {
			return self.segmentItems[0]
		}
	}
	
	func alterDefaults() {
		storedData.set(segmentItems[control.selectedSegmentIndex], forKey: nameLabel.text!)
		
		print(segmentItems[control.selectedSegmentIndex])
	}
	
	override func setupViews() {
		addSubview(nameLabel)
		addSubview(control)
		
		control.addTarget(self, action: #selector(alterDefaults), for: .valueChanged)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]->=50-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": control]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": control]))
	}	
}
