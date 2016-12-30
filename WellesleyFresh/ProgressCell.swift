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
	
	var mealText = ""
	
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
	
	var progress: UIProgressView = {
		let prog = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
		prog.layer.cornerRadius = 0.0
		prog.layer.masksToBounds = true
		prog.progressTintColor = UIColor.blue
//		prog.layer.
		prog.translatesAutoresizingMaskIntoConstraints = false
		return prog
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	func absoluteValue(a:Float, b:Float) -> Float {
		if a > b {
			return a - b
		} else {
			return b - a
		}
	}
	
	func setProgressFloat(_ num: Float) {
		print("Progress:", num)
		if  absoluteValue(a: progress.progress, b: num) > 0.03 {
//			print("Progress was wildly different.")
//			progress = UIProgressView(progressViewStyle: .default)
//			progress.layer.cornerRadius = 0.0
//			progress.layer.masksToBounds = true
			progress.progress = num

//			setupViews()
		} else {
			progress.setProgress(num, animated: true)
		}
	}
	
	func setProgressDouble(_ num: Double) {
		setProgressFloat(Float(num))
//		if abs(progress.progress - Float(num)) > 0.03 {
//			print("Progress was wildly different.")
//			progress = UIProgressView(progressViewStyle: .default)
//			progress.layer.cornerRadius = 0.0
//			progress.layer.masksToBounds = true
//			progress.progress = Float(num)
////			setupViews()
//
//		} else {
//			progress.setProgress(Float(num), animated: true)
//		}
	}
	
	func compareColors(a:UIColor, b:UIColor) -> Bool {
		let componentsA:[CGFloat] = a.cgColor.components!
		let componentsB:[CGFloat] = b.cgColor.components!
		var truth:Bool = true
		for i in 0..<componentsA.count {
			truth = truth && (absoluteValue(a: Float(componentsA[i]), b: Float(componentsB[i])) < 0.01)
		}
		return truth
	}
	
	func setMealLabel(label:String) {
		if !mealText.contains(label) {
			mealText = label
			mealLabel.text? = mealText
			if mealText.contains("Closed") && !self.compareColors(a: self.progress.progressTintColor!, b: UIColor.red) {
				self.progress.progressTintColor = UIColor.red
			} else if mealText.contains("Next") && !self.compareColors(a: self.progress.progressTintColor!, b: UIColor.orange){
				self.progress.progressTintColor = UIColor.orange
			} else {
				self.progress.progressTintColor = UIColor.blue
			}
		}
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
