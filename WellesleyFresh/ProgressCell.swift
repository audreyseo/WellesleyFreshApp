//
//  ProgressCell.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 22/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Sample Item"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFontOfSize(14)
		label.numberOfLines = 0
		return label
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = NSTextAlignment.Right
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFontOfSize(10)
		label.numberOfLines = 0
		return label
	}()
	
	let timeLeft: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = NSTextAlignment.Left
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFontOfSize(10)
		label.numberOfLines = 0
		return label
	}()
	
	let mealLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFontOfSize(12)
		label.numberOfLines = 0
		return label
	}()
	
	let progress: UIProgressView = {
		let prog = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
		prog.translatesAutoresizingMaskIntoConstraints = false
		return prog
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	func setProgress(num: Float) {
		progress.setProgress(num, animated: false);
	}
	
	func setProgressDouble(num: Double) {
		progress.setProgress(Float(num), animated: false)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupViews() {
		addSubview(nameLabel)
		addSubview(mealLabel)
		addSubview(timeLabel)
		addSubview(progress)
		addSubview(timeLeft)
		let timeWidth = 45
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0(85)]-4-[v1]-8-[v2(\(timeWidth))]-4-[v3(100)]-4-[v4(\(timeWidth))]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": mealLabel, "v2": timeLabel, "v3": progress, "v4": timeLeft]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mealLabel]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": progress]))
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLeft]))
	}
}
