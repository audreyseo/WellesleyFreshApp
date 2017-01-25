//
//  AboutPageVC.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 10/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit
import MessageUI


class AboutPageViewController:UITableViewController, MFMailComposeViewControllerDelegate {
	
	var items:[String] = [
		"The Wellesley Fresh iPhone App",
		"by Audrey Seo '20",
		"",
		"This app is officially associated with neither the Wellesley Fresh team nor Wellesley College, but is however programmed and designed by a Wellesley College student, Audrey Seo, for their fellow students.",
		"Tap here to contribute to the Wellesley Fresh App open-source project on GitHub.",
		"Credits",
		"App Icon Designer",
		"Abigail Conte '20",
		"App Testers",
		"Auriel Haack '20",
		"Minnie Seo",
		"iPhone Compatibility",
		"Claire Seo",
		"Michael Seo",
		"Consultants",
		"Graphics",
		"Claire Seo",
		"Acknowledgments",
		"Software Bug Hunters",
		"Christiane Joseph '20",
		"Comments? Questions? Bugs? Email me."]
	let types:[AboutCellStyle] = [
		.title,
		.subtitle,
		.version,
		.paragraph,
		.button,
		.firstLevel,
		.secondLevel,
		.thirdLevel,
		.secondLevel,
		.thirdLevel,
		.thirdLevel,
		.secondLevel,
		.thirdLevel,
		.thirdLevel,
		.secondLevel,
		.thirdLevel,
		.fourthLevel,
		.firstLevel,
		.secondLevel,
		.thirdLevel,
		.button
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.separatorStyle = .none
		tableView.register(AboutCell.self, forCellReuseIdentifier: "aboutCell")
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 140
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "aboutCell") as! AboutCell
		c.setStyle(newStyle: types[indexPath.row])
		c.selectionStyle = .none
		if types[indexPath.row] == .version {
			items[indexPath.row] = "Version: \(getAppVersion())"
		}
		
		if types[indexPath.row] == .button {
			c.setButtonTitle(titleString: items[indexPath.row])
			
			switch items[indexPath.row] {
			case items[4]:
				c.actionButton.addTarget(self, action: #selector(gotoSourceCode), for: .touchUpInside)
			case items[items.endIndex - 1]:
				c.actionButton.addTarget(self, action: #selector(contactMe), for: .touchUpInside)
			default:
				break
			}
			
		} else {
			c.setLabel(labelString: items[indexPath.row])
		}
		c.setupViews()
		
		return c
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	
	func gotoSourceCode() {
		let alert = UIAlertController(title: "Open Page in Safari", message: "Are you sure you want to open up the GitHub source code in Safari?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			UIApplication.shared.openURL(URL(string: "https://github.com/audreyseo/WellesleyFreshApp")!)
			return;
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

	func contactMe() {
		let contactor = configuredMailComposeViewController("aseo@wellesley.edu")
		if MFMailComposeViewController.canSendMail() {
			contactor.navigationItem.title = "Contact and Feedback"
			self.present(contactor, animated: true, completion: nil)
			//self.navigationController?.pushViewController(contactor, animated: true)
		}
	}
	
	func getAppVersion() -> String {
		let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String as AnyObject?
		return nsObject as! String
	}

	func configuredMailComposeViewController(_ target:String) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients([target])
//		let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String as AnyObject?
		let version = getAppVersion()
		
		//if version != nil {
		mailComposerVC.setSubject("[WellesleyFreshApp - v\(version)]: ")
		mailComposerVC.setMessageBody("", isHTML: false)
		//}
		
		return mailComposerVC
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: false, completion: nil)
	}
}
