//
//  AboutCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 15/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit

enum AboutCellStyle {
	case title, subtitle, version, firstLevel, secondLevel, thirdLevel, fourthLevel, paragraph, button
}


class AboutCell:UITableViewCell {
	var cellStyle: AboutCellStyle = .title
	var cellIndent: Int = 0
	var cellTop: Int = 0
	var cellBot: Int = 0
	//	var myTableViewController: SecondViewController?
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
//		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Sample Item"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		return label
	}()
	
	let actionButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Delete", for: UIControlState())
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	func setLabel(labelString: String) {
		actionButton.removeFromSuperview()
		nameLabel.removeFromSuperview()
		nameLabel.text = labelString
	}
	
	func setButtonTitle(titleString: String) {
		nameLabel.removeFromSuperview()
		actionButton.removeFromSuperview()
		actionButton.autoresizingMask = .flexibleHeight
		actionButton.setTitle(titleString, for: .normal)
		actionButton.titleLabel?.numberOfLines = 0
		
//		actionButton.sizeThatFits((actionButton.titleLabel?.frame.size)!)
		actionButton.sizeToFit()
//		print("Action button frame: \(actionButton.frame.size.height)")
//		print("Action button: \((actionButton.titleLabel?.frame.size.height)! * 1.1)")
//		actionButton.frame.size.height = (actionButton.titleLabel?.frame.size.height)! * 1.1
	}
	
	func setStyle(newStyle: AboutCellStyle) {
		self.cellStyle = newStyle
		
		var fsize = 10.0
		switch self.cellStyle {
		case .title:
			fsize = 25.0
			cellIndent = 0
			cellTop = 8
			cellBot = 0
		case .subtitle:
			fsize = 18.0
			cellIndent = 16
			cellTop = 4
			cellBot = 2
		case .version:
			fsize = 14.0
			cellIndent = 16
			cellTop = 0
			cellBot = 4
		case .firstLevel:
			fsize = 23.0
			cellIndent = 0
			cellTop = 16
			cellBot = 0
		case .secondLevel:
			fsize = 17.0
			cellIndent = 8
			cellTop = 4
			cellBot = 2
		case .thirdLevel:
			fsize = 15.0
			cellIndent = 16
			cellTop = 2
			cellBot = 1
		case .fourthLevel:
			fsize = 13.0
			cellIndent = 24
			cellTop = 1
			cellBot = 1
		case .paragraph:
			fsize = 12.0
			cellIndent = 0
			cellTop = 4
			cellBot = 4
		case .button:
			fsize = 18.0
			cellIndent = 0
			cellTop = 4
			cellBot = 4
		}
		
		cellIndent += 16
		self.nameLabel.font = UIFont.systemFont(ofSize: CGFloat(fsize))
	}
	
	func setupViews() {
		if cellStyle != .button {
			addSubview(nameLabel)
			
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(cellIndent)-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(cellTop)-[v0]-\(cellBot)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		} else {
			addSubview(actionButton)
			
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(cellIndent)-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
			addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(cellTop)-[v0(>=40)]-\(cellBot)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
		}
	}
}
