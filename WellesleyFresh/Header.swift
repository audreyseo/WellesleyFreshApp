//
//  Header.swift
//  tableViewApp
//
//  Created by Audrey Seo on 10/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class Header: UITableViewHeaderFooterView {
//	var myTableViewController: SecondViewController?
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let nameLabel: UILabel = {
		let label = UILabel()
//		label.text = "My Header"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	
	
	func setupViews() {
		addSubview(nameLabel)
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
	}
}
