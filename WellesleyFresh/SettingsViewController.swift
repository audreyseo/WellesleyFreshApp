//
//  SettingsViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 15/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
	var tableview:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .grouped)
	var units:String = "Preferred Units"
	var unitOptions:[String] = ["m", "km", "ft", "yd", "mi"]
	var items: [[String]] = [["Preferred Units", "Table Scrolls to Closest Meal", "Default Dining Hall"], ["Contact and Support", "Source Code on GitHub", "Visit the Wellesley Fresh Website", "Version", "About"], []] //[["Bates", "Lulu Chow Wang", "Pomeroy", "Stone-Davis", "Tower"], ["Bagged Lunch Form"], ["Preferred Units", "Contact", "About"]]
	var titles:[String] = ["", "", ""] //["Feedback", "Order", "Settings"]
	
	var disclosureCells:[String] = ["About", "Bagged Lunch Form", "Contact and Support", "Source Code on GitHub", "Visit the Wellesley Fresh Website"]
	var switchCells:[String] = ["Table Scrolls to Closest Meal"]
	var switchSelectors:[Selector]!
	var switchKeys:[String] = ["tableScrollsToNextMealKey"]
	
	var defs = UserDefaults()
	
	let defaultDiningHallKey = "defaultDiningHallKey"
	
	let hallInputView:UIInputView = UIInputView()
	let picker = UIPickerView()
	let toolbar = UIToolbar()
	
	let diningHalls = ["Bae Pao Lu Chow", "Bates", "Pomeroy", "Stone Davis", "Tower"]
	var selectedDiningHall = "NONE"
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		switchSelectors = [#selector(self.scrollToNextMeal)]
		
		self.tableview.register(MyCell.self, forCellReuseIdentifier: "cellId")
		self.tableview.register(SegmentedControlCell.self, forCellReuseIdentifier: "segmentedCellId")
		self.tableview.register(CustomButtonCell.self, forCellReuseIdentifier: "buttonCellId")
		self.tableview.register(SwitchCell.self, forCellReuseIdentifier: "switchCellId")
		
		// Assigns the class Header to the type of header cell that we use
		self.tableview.register(GroupHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
		
		self.tableview.delegate = self
		self.tableview.dataSource = self
		
		self.tableview.sizeToFit()
		
		// ty to this tutorial for the following code for auto-height for cells: https://www.raywenderlich.com/129059/self-sizing-table-view-cells
		self.tableview.estimatedRowHeight = 140
		
		
		self.view.addSubview(tableview)
		
		// Add a title to the thing
		self.navigationItem.title = "Settings"
		
		
		let barButtonDone:UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.madeSelection))
		let barButtonSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let barButtonCancel:UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.madeSelection))
		
		picker.isHidden = false
		picker.dataSource = self
		picker.delegate = self
		picker.backgroundColor = UIColor.white
		picker.showsSelectionIndicator = true
		
		toolbar.barStyle = UIBarStyle.default
		toolbar.isTranslucent = true
		
		toolbar.setItems([barButtonCancel, barButtonSpace, barButtonDone], animated: false)
		hallInputView.addSubview(toolbar)
		hallInputView.addSubview(picker)
		hallInputView.isHidden = true
		
		hallInputView.backgroundColor = UIColor.white
		
		self.view.addSubview(hallInputView)
		
		if defs.string(forKey: defaultDiningHallKey) != nil {
			if defs.string(forKey: defaultDiningHallKey) != "NONE" {
				selectedDiningHall = defs.string(forKey: defaultDiningHallKey)!
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		let tableX:CGFloat = self.view.frame.size.width * 0.0
		let tableY:CGFloat = 0.0 //(self.navigationController?.navigationBar.frame.size.height)! //+ (self.navigationController?.navigationBar.frame.origin.y)!
		let tableW:CGFloat = self.view.frame.size.width * 1.0
		let tableH:CGFloat = (self.view.frame.size.height - tableY);
		self.tableview.frame = CGRect(x: CGFloat(tableX), y: tableY, width: tableW, height: tableH)
		
		//print("(", UIColor.groupTableViewBackground.cgColor.components?[0], ",", UIColor.groupTableViewBackground.cgColor.components?[1], ",", UIColor.groupTableViewBackground.cgColor.components?[2], ")")
		let footerView = GroupHeader(reuseIdentifier: "headerId")
		footerView.nameLabel.text = ""
		footerView.isOpaque = true
		
		// Need to delete either one of these but all I wanted is for the background to be normal hallelujah
		self.tableview.backgroundColor = UIColor.groupTableViewBackground
		self.view.backgroundColor = UIColor.groupTableViewBackground
		self.tableview.tableFooterView = footerView
		self.tableview.tableFooterView?.tintColor = UIColor.groupTableViewBackground //UIColor.init(red: 53, green: 60, blue: 62, alpha: 255)		
		
		self.picker.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 400)
		hallInputView.frame = CGRect(x: 0, y: self.view.frame.origin.y + self.view.frame.size.height * 0.4, width: tableview.contentSize.width, height: self.view.frame.size.height * 0.5 + 40)
		toolbar.frame = CGRect(x: 0, y: 0, width: self.tableview.contentSize.width, height: 40)
	}
	
	// ---------------------DELEGATE METHODS----------------------
	
	// Tableview
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return titles.count
	}
	
	func getAppVersion() -> String {
		let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String as AnyObject?
		return nsObject as! String
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (items[indexPath.section][indexPath.row].hasPrefix(units)) {
//			print("Making a segmented control cell.")
			let myCell = tableView.dequeueReusableCell(withIdentifier: "segmentedCellId", for: indexPath) as! SegmentedControlCell
			if (items[indexPath.section].count > 0) {
				myCell.nameLabel.text = items[indexPath.section][indexPath.row]
			} else {
				myCell.nameLabel.text = ""
			}
			myCell.setupSegmentedControl(items: unitOptions)
			return myCell
		} else if switchCells.contains(items[indexPath.section][indexPath.row]) {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "switchCellId", for: indexPath) as! SwitchCell
			myCell.nameLabel.text = items[indexPath.section][indexPath.row]
			let ind = switchCells.index(of: items[indexPath.section][indexPath.row])
			myCell.switchView.addTarget(self, action: switchSelectors[ind!], for: .valueChanged)
			myCell.switchView.isOn = UserDefaults().bool(forKey: switchKeys[ind!])
			return myCell
		} else if titles[indexPath.section].contains("Feedback") {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "buttonCellId", for: indexPath) as! CustomButtonCell
			
			myCell.nameButton(newName: items[indexPath.section][indexPath.row])
			switch items[indexPath.section][indexPath.row] {
				case "Bates":
				myCell.actionButton.addTarget(self, action: #selector(batesFeedback), for: .touchUpInside)
				case "Lulu Chow Wang":
				myCell.actionButton.addTarget(self, action: #selector(bplcFeedback), for: .touchUpInside)
				case "Pomeroy":
				myCell.actionButton.addTarget(self, action: #selector(pomFeedback), for: .touchUpInside)
				case "Stone-Davis":
				myCell.actionButton.addTarget(self, action: #selector(stonedFeedback), for: .touchUpInside)
				case "Tower":
				myCell.actionButton.addTarget(self, action: #selector(towerFeedback), for: .touchUpInside)
			default:
				break;
			}
			myCell.accessoryType = .disclosureIndicator
			
			return myCell
		} else {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
			if (items[indexPath.section].count > 0) {
				
				switch items[indexPath.section][indexPath.row] {
				case "Version":
					myCell.nameLabel.text = "Version: \(getAppVersion())"
				case "Default Dining Hall":
					myCell.nameLabel.text = "Default Dining Hall: \(selectedDiningHall)"
					myCell.accessoryType = .detailDisclosureButton
				default:
					myCell.nameLabel.text = items[indexPath.section][indexPath.row]
					if disclosureCells.contains(items[indexPath.section][indexPath.row]) {
						myCell.accessoryType = .disclosureIndicator
					}
					break
				}
				
//				if items[indexPath.section][indexPath.row] == "Version" {
//					myCell.nameLabel.text = "Version: \(getAppVersion())"
//				} else {
//					
//				}
			} else {
				myCell.nameLabel.text = ""
			}
			
			return myCell
		}
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		let ac = UIAlertController(title: "Default Dining Hall", message: "This setting determines which dining hall's menu will be automatically loaded in the Menu tab.", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
		ac.addAction(action)
		
		self.navigationController?.present(ac, animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch items[indexPath.section][indexPath.row] {
		case "About":
			self.aboutPageSegue()
			break;
		case "Contact and Support":
			self.contact()
		case "Source Code on GitHub":
			self.sourceCode()
		case "Visit the Wellesley Fresh Website":
			self.wellesleyFreshSite()
		case "Default Dining Hall":
			self.pickDefaultDiningHall()
		default:
			break;
			
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return titles[section]
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! GroupHeader
		myHeader.contentView.backgroundColor = UIColor.groupTableViewBackground
		return myHeader
	}
	
	
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return 40
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section < items.count {
			return items[section].count
		} else {
			return 0
		}
	}
	
	
	// UIPickerView
	
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return diningHalls.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return diningHalls[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedDiningHall = diningHalls[row]
		print("Selected: ", selectedDiningHall)
	}
	
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return tableview.contentSize.width * 0.8
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 40
	}
}

// Table view helper methods
extension SettingsViewController {
	func getCell(tableView: UITableView, ip: IndexPath) -> UITableViewCell {
		if (items[ip.section][ip.row].hasPrefix(units)) {
			//			print("Making a segmented control cell.")
			let myCell = tableView.dequeueReusableCell(withIdentifier: "segmentedCellId", for: ip) as! SegmentedControlCell
			if (items[ip.section].count > 0) {
				if items[ip.section][ip.row] == "Version" {
					myCell.nameLabel.text = "Version: \(getAppVersion())"
				} else {
					myCell.nameLabel.text = items[ip.section][ip.row]
				}
			} else {
				myCell.nameLabel.text = ""
			}
			myCell.setupSegmentedControl(items: unitOptions)
			return myCell
		} else if switchCells.contains(items[ip.section][ip.row]) {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "switchCellId", for: ip) as! SwitchCell
			myCell.nameLabel.text = items[ip.section][ip.row]
			let ind = switchCells.index(of: items[ip.section][ip.row])
			myCell.switchView.addTarget(self, action: switchSelectors[ind!], for: .valueChanged)
			myCell.switchView.isOn = UserDefaults().bool(forKey: switchKeys[ind!])
			return myCell
		} else if titles[ip.section].contains("Feedback") {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "buttonCellId", for: ip) as! CustomButtonCell
			
			myCell.nameButton(newName: items[ip.section][ip.row])
			switch items[ip.section][ip.row] {
			case "Bates":
				myCell.actionButton.addTarget(self, action: #selector(batesFeedback), for: .touchUpInside)
			case "Lulu Chow Wang":
				myCell.actionButton.addTarget(self, action: #selector(bplcFeedback), for: .touchUpInside)
			case "Pomeroy":
				myCell.actionButton.addTarget(self, action: #selector(pomFeedback), for: .touchUpInside)
			case "Stone-Davis":
				myCell.actionButton.addTarget(self, action: #selector(stonedFeedback), for: .touchUpInside)
			case "Tower":
				myCell.actionButton.addTarget(self, action: #selector(towerFeedback), for: .touchUpInside)
			default:
				break;
			}
			myCell.accessoryType = .disclosureIndicator
			
			return myCell
		} else {
			let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: ip) as! MyCell
			if (items[ip.section].count > 0) {
				myCell.nameLabel.text = items[ip.section][ip.row]
				if disclosureCells.contains(items[ip.section][ip.row]) {
					myCell.accessoryType = .disclosureIndicator
				}
			} else {
				myCell.nameLabel.text = ""
			}
			
			return myCell
		}
	}
}

// Mail/Messaging delegate methods
extension SettingsViewController: MFMailComposeViewControllerDelegate {
	func configuredMailComposeViewController(_ target:String) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients([target])
		let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String as AnyObject?
		let version = nsObject as! String
		
		//if version != nil {
		mailComposerVC.setSubject("[WellesleyFreshApp - v\(version)]: ")
		mailComposerVC.setMessageBody("", isHTML: false)
		//}
		
		return mailComposerVC
	}
	
	func configuredMailComposeViewController(_ target:String, message: String) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients([target])
		let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String as AnyObject?
		let version = nsObject as! String
		
		//if version != nil {
		mailComposerVC.setSubject("[WellesleyFreshApp - v\(version)]: ")
		mailComposerVC.setMessageBody(message, isHTML: false)
		//}
		
		return mailComposerVC
	}
	
	func showSendMailErrorAlert() {
		let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		sendMailErrorAlert.addAction(defaultAction)
		
		present(sendMailErrorAlert, animated: true, completion: nil)
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: false, completion: nil)
	}
}


// Contains various contact/mailing helper functions
extension SettingsViewController {
	func contact() {
		let contactor = configuredMailComposeViewController("aseo@wellesley.edu", message: "Model: \(UIDevice.current.modelName)\niOS version: \(UIDevice.current.systemVersion)\n\nComments:\n\n")
		if MFMailComposeViewController.canSendMail() {
			contactor.navigationItem.title = "Contact and Feedback"
			self.present(contactor, animated: true, completion: nil)
			//self.navigationController?.pushViewController(contactor, animated: true)
		}
	}
	
	
	func pomFeedback(_ sender: AnyObject) {
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "pomFeedbackView")
		nextViewController?.navigationItem.title = "Review Pomeroy"
		self.navigationController?.pushViewController(nextViewController!, animated:true)
	}
	func towerFeedback(_ sender: AnyObject) {
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "pomFeedbackView")
		nextViewController?.navigationItem.title = "Review Tower"
		self.navigationController?.pushViewController(nextViewController!, animated:true)
	}
	func stonedFeedback(_ sender: AnyObject) {
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "pomFeedbackView")
		nextViewController?.navigationItem.title = "Review Stone-Davis"
		self.navigationController?.pushViewController(nextViewController!, animated:true)
	}
	func batesFeedback(_ sender: AnyObject) {
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "pomFeedbackView")
		nextViewController?.navigationItem.title = "Review Bates"
		self.navigationController?.pushViewController(nextViewController!, animated:true)
	}
	func bplcFeedback(_ sender: AnyObject) {
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "pomFeedbackView")
		nextViewController?.navigationItem.title = "Review Lulu"
		self.navigationController?.pushViewController(nextViewController!, animated:true)
	}
}


// Adding various looaders and helpers.
extension SettingsViewController {
	func madeSelection() {
		hallInputView.isHidden = true
		print("Hiding")
		if selectedDiningHall != "NONE" {
			defs.set(selectedDiningHall, forKey: defaultDiningHallKey)
			tableview.reloadData()
		}
	}
	
	func pickDefaultDiningHall() {
		print("Showing")
		hallInputView.isHidden = false
		if selectedDiningHall != "NONE" {
			let ind = diningHalls.index(of: selectedDiningHall)
			if ind != nil {
				picker.selectRow(ind!, inComponent: 0, animated: true)
			}
		}
		
	}
	
	func scrollToNextMeal(_ sender: UISwitch) {
		print("Scrolling to next meal?: \(sender.isOn)")
		let userdefs = UserDefaults()
		userdefs.set(sender.isOn, forKey: "tableScrollsToNextMealKey")
	}
	
	func wellesleyFreshSite() {
		let alert = UIAlertController(title: "Open Page in Safari", message: "Are you sure you want to open up the Wellesley Fresh website in Safari?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			UIApplication.shared.openURL(URL(string: "http://www.wellesleyfresh.com")!)
			return;
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func sourceCode() {
		let alert = UIAlertController(title: "Open Page in Safari", message: "Are you sure you want to open up the GitHub source code in Safari?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			UIApplication.shared.openURL(URL(string: "https://github.com/audreyseo/WellesleyFreshApp")!)
			return;
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func aboutPageSegue() {
		let next = self.storyboard?.instantiateViewController(withIdentifier: "aboutViewController")
		next?.navigationItem.title = "About"
		self.navigationController?.pushViewController(next!, animated: true)
	}
}
