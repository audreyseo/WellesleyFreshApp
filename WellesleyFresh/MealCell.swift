//
//  MealCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 23/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

class MealCell: Header {
	
	var mealLabel: UILabel {
		let label = UILabel()
		label.text = ""
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupViews() {
		addSubview(mealLabel)
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mealLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=6-[v0(>=30)]-2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mealLabel]))
	}
}
