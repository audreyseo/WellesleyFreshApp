//
//  AboutPageVC.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 10/1/2017.
//  Copyright © 2017 Audrey Seo. All rights reserved.
//

import UIKit
import MessageUI


class AboutPageViewController:UIViewController, MFMailComposeViewControllerDelegate {
	@IBAction func githubSourceCode(_ sender: Any) {
		let alert = UIAlertController(title: "Open Page in Safari", message: "Are you sure you want to open up the GitHub source code in Safari?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			UIApplication.shared.openURL(URL(string: "https://github.com/audreyseo/WellesleyFreshApp")!)
			return;
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func emailMe(_ sender: Any) {
		let contactor = configuredMailComposeViewController("aseo@wellesley.edu")
		if MFMailComposeViewController.canSendMail() {
			contactor.navigationItem.title = "Contact and Feedback"
			self.present(contactor, animated: true, completion: nil)
			//self.navigationController?.pushViewController(contactor, animated: true)
		}
	}
	
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
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: false, completion: nil)
	}
}
