//
//  SwitchCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 19/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit


class SwitchCell: MyCell {
	
	let switchView: UISwitch = {
		let s = UISwitch()
		s.translatesAutoresizingMaskIntoConstraints = false
		s.isOn = false
		return s
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func setupViews() {
		addSubview(nameLabel)
		addSubview(switchView)
		
		let viewDict:[String: Any?] = ["v0": nameLabel, "v1": switchView]
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]->=4-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
	}
}
