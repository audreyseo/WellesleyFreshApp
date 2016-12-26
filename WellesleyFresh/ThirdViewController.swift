//
//  ThirdViewController.swift
//  WellesleyFresh
//
//  Created by Audrey Seo on 15/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit
import MessageUI

class ThirdViewController: UIViewController, MFMailComposeViewControllerDelegate {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func configuredMailComposeViewController(_ targetHall:String) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients(["\(targetHall)@somewhere.com"])
		mailComposerVC.setSubject("Sending an in-app email")
		mailComposerVC.setMessageBody("Start of an email!!\n", isHTML: false)
		
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
	
	@IBAction func pomFeedback(_ sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Pomeroy")
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func towerFeedback(_ sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Tower")
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func stonedFeedback(_ sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Stone_D")
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func batesFeedback(_ sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Bates")
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func bplcFeedback(_ sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("BPLC")
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	
}
