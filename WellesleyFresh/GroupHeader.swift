//
//  GroupHeader.swift
//  tableViewApp
//
//  Created by Audrey Seo on 10/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class GroupHeader: Header {	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupViews() {
		contentView.addSubview(nameLabel)
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]->=16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(26)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
	}
}
