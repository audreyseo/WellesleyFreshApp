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
	
	func configuredMailComposeViewController(targetHall:String) -> MFMailComposeViewController {
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		
		mailComposerVC.setToRecipients(["\(targetHall)@somewhere.com"])
		mailComposerVC.setSubject("Sending an in-app email")
		mailComposerVC.setMessageBody("Start of an email!!\n", isHTML: false)
		
		return mailComposerVC
	}
	
	func showSendMailErrorAlert() {
		let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		sendMailErrorAlert.addAction(defaultAction)
		
		presentViewController(sendMailErrorAlert, animated: true, completion: nil)
	}
	
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		controller.dismissViewControllerAnimated(false, completion: nil)
	}
	
	@IBAction func pomFeedback(sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Pomeroy")
		if MFMailComposeViewController.canSendMail() {
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func towerFeedback(sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Tower")
		if MFMailComposeViewController.canSendMail() {
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func stonedFeedback(sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Stone_D")
		if MFMailComposeViewController.canSendMail() {
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func batesFeedback(sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("Bates")
		if MFMailComposeViewController.canSendMail() {
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	@IBAction func bplcFeedback(sender: AnyObject) {
		let mailComposeViewController = configuredMailComposeViewController("BPLC")
		if MFMailComposeViewController.canSendMail() {
			self.presentViewController(mailComposeViewController, animated: true, completion: nil)
		} else {
			self.showSendMailErrorAlert()
		}
	}
	
}