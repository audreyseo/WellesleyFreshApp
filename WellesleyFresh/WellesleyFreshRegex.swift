//
//  WellesleyFreshRegex.swift
//  tableViewApp
//
//  Created by Audrey Seo on 10/10/2016.
//  Copyright © 2016 Audrey Seo. All rights reserved.
//

import UIKit

class WellesleyFreshRegex {
	let deleteLineBreaks:String = "\n|\r"
	let reorganizeString:String = "\\s*<span class=\"SpellE\"\\s*>([a-zA-Z]+)<\\/span>\\s*"
	let titleExtractor:String = "<b[^>]+><span[^>]+>(Brunch|Dinner|Lunch)<\\/span><\\/b>"
	let mealItemExtractor:String = "<p[^>]+><b><span[^>]+>((?:[-a-zA-Z]+(?: [-a-zA-Z]+)* (?:Lunch|Dinner))|(?:Soup))-?\\s?<\\/span><\\/b><span[^>]+>([^<]+)<\\/span>"
	var bodyExtraction:String = ".*<div[^>]+>((.(?!<\\/div>))*).*"
	var spanDeletionPattern:String = "<\\/?span[^>]*>"
	var allElementDeletion:String = "<[^>]*>"
	var deleteBreaks:String = "&nbsp;"
	var deleteLines:String = "[\n\r]{3,400}"
	let deleteForwardSlashes:String = "\\/"
	var trimPattern:String = "^\\s*([-a-zA-Z\n\'\";, ]+)\\s*$"
	var makeLineBreaks:String = "\u{0020}{3,400}"
	var ampersand:String = "&amp;"
	
	var deleteLineBreaksRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: deleteLineBreaks, options: [])
	}
	var reductionRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: reorganizeString, options: [])
	}
	var titleRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: titleExtractor, options: [])
	}
	var mealRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: mealItemExtractor, options: [])
	}
	var bodyRegex: NSRegularExpression? {
		return try! NSRegularExpression(pattern: bodyExtraction, options: NSRegularExpression.Options.dotMatchesLineSeparators)
	}
	var spanDeleterRegex: NSRegularExpression? {
		return try! NSRegularExpression(pattern: spanDeletionPattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
	}
	var elementDeleterRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: allElementDeletion, options: NSRegularExpression.Options.dotMatchesLineSeparators)
	}
	var brDeleteRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: deleteBreaks, options: [])
	}
	var deleteEmptyRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: deleteLines, options: [])
	}
	var deleteForwardSlashesRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: deleteForwardSlashes, options: [])
	}
	var separateRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: makeLineBreaks, options: [])
	}
	var replaceAmpersandsRegex:NSRegularExpression? {
		return try! NSRegularExpression(pattern: ampersand, options: [])
	}
	
	var replaceDoubleCarriageReturns:NSRegularExpression? {
		return try! NSRegularExpression(pattern: "[\n\r]{2,10000}", options: [])
	}
	
	init() {
		// hello there
	}
	
	func extractString(_ inputString:String, regex:NSRegularExpression, regexTemplate:String) -> String {
		return regex.stringByReplacingMatches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.characters.count), withTemplate: regexTemplate)
	}
	
	func extractInformationString(_ input:String) -> String {
		var bodyString:String = self.extractString(input as String, regex: self.bodyRegex!, regexTemplate: "$1")
		bodyString = self.extractString(bodyString, regex: self.deleteLineBreaksRegex!, regexTemplate: "\u{0020}")
//		bodyString = self.extractString(bodyString, regex: self.mealRegex!, regexTemplate: "|$1|[|]$2[|]")
		bodyString = self.extractString(bodyString, regex: self.reductionRegex!, regexTemplate: "$1")
//		bodyString = self.extractString(bodyString, regex: self.titleRegex!, regexTemplate: "||$1||")
		
		bodyString = self.extractString(bodyString, regex: self.spanDeleterRegex!, regexTemplate: "")
		bodyString = self.extractString(bodyString, regex: self.elementDeleterRegex!, regexTemplate: "")
		bodyString = self.extractString(bodyString, regex: self.brDeleteRegex!, regexTemplate: "")
		bodyString = self.extractString(bodyString, regex: self.deleteForwardSlashesRegex!, regexTemplate: "")
		bodyString = self.extractString(bodyString, regex: self.elementDeleterRegex!, regexTemplate: "")
		
		
		bodyString = self.extractString(bodyString, regex: self.separateRegex!, regexTemplate: "\n")
		bodyString = self.extractString(bodyString, regex: self.deleteEmptyRegex!, regexTemplate: "\n")
		bodyString = self.extractString(bodyString, regex: self.elementDeleterRegex!, regexTemplate: "")
		bodyString = self.extractString(bodyString, regex: self.replaceAmpersandsRegex!, regexTemplate: "&")
		bodyString = self.extractString(bodyString, regex: self.replaceDoubleCarriageReturns!, regexTemplate: "\n")
		bodyString = bodyString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		return bodyString
	}
}
