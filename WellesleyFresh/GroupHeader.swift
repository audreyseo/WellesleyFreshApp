//
//  GroupHeader.swift
//  tableViewApp
//
//  Created by Audrey Seo on 10/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class GroupHeader: Header {
	//	var myTableViewController: SecondViewController?
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
//		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	let nameLabel: UILabel = {
//		let label = UILabel()
//		//		label.text = "My Header"
//		//label.text = ""
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.font = UIFont.boldSystemFont(ofSize: 18)
//		label.numberOfLines = 0
//		return label
//	}()
	
	
	
	override func setupViews() {
		addSubview(nameLabel)
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=6-[v0(>=30)]-2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
	}
}
