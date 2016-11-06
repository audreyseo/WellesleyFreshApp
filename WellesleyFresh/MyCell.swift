//
//  MyCell.swift
//  tableViewApp
//
//  Created by Audrey Seo on 10/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
	
//	var myTableViewController: SecondViewController?
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Sample Item"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFontOfSize(14)
		label.numberOfLines = 0
		return label
	}()
	
	let actionButton: UIButton = {
		let button = UIButton(type: .System)
		button.setTitle("Delete", forState: .Normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	func setupViews() {
		addSubview(nameLabel)
		//		addSubview(actionButton)
		
//		actionButton.addTarget(self, action: "handleAction", forControlEvents: .TouchUpInside)
		
		
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
	}
	
//	func handleAction() {
//		myTableViewController?.deleteCell(self)
//	}
}