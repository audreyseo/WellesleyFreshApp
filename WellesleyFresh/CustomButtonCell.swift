//
//  ButtonCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 26/12/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit


class CustomButtonCell:MyCell {
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func nameButton(newName:String) {
		actionButton.setTitle(newName, for: UIControlState())
	}
	
	override func setupViews() {
		addSubview(actionButton)

		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
	}
}
