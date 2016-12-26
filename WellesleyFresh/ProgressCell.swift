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
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		return label
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = NSTextAlignment.right
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 10)
		label.numberOfLines = 0
		return label
	}()
	
	let timeLeft: UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = NSTextAlignment.left
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 10)
		label.numberOfLines = 0
		return label
	}()
	
	let mealLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 12)
		label.numberOfLines = 0
		return label
	}()
	
	let progress: UIProgressView = {
		let prog = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
		prog.translatesAutoresizingMaskIntoConstraints = false
		return prog
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	func setProgress(_ num: Float) {
		progress.setProgress(num, animated: false);
	}
	
	func setProgressDouble(_ num: Double) {
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
		let hallNameWidth = 60
		let timeWidth = 45
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(hallNameWidth))]-4-[v1]-8-[v2(\(timeWidth))]-4-[v3(100)]-4-[v4(\(timeWidth))]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": mealLabel, "v2": timeLabel, "v3": progress, "v4": timeLeft]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mealLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": progress]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLeft]))
	}
}
