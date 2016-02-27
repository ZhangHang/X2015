//
//  NotePreviewViewController.swift
//  X2015
//
//  Created by Hang Zhang on 2/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import WebKit

class NotePreviewViewController: ThemeAdaptableViewController {

	struct SegueIdentifier {
		static let Present = "PreviewNoteSegueIdentifier"
	}

	let webView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	var noteContent: String!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupWebView()
		loadTemplate()
	}

	private func setupWebView() {
		automaticallyAdjustsScrollViewInsets = false
		view.addSubview(webView)
		view.addConstraints(
			NSLayoutConstraint
				.constraintsWithVisualFormat(
					"H:|[webview]|",
					options: .DirectionLeadingToTrailing,
					metrics: nil,
					views: ["webview": webView])
		)
		view.addConstraints(
			NSLayoutConstraint
				.constraintsWithVisualFormat(
					"V:[topGuide][webview]|",
					options: .DirectionLeadingToTrailing,
					metrics: nil,
					views: ["webview": webView, "topGuide": topLayoutGuide])
		)
		webView.opaque = false
		webView.navigationDelegate = self
	}

	private func loadTemplate() {
		guard let templatePath = NSBundle.mainBundle().pathForResource("default", ofType: "html") else {
			fatalError()
		}
		let url = NSURL(fileURLWithPath: templatePath)
		let request = NSURLRequest(URL: url)
		webView.loadRequest(request)
	}

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		super.updateThemeInterface(theme, animated: animated)
		super.configureTheme(theme)
		switch theme {
		case .Default:
			webView.evaluateJavaScript("enableDarkTheme(false)", completionHandler: nil)
		case .Night:
			webView.evaluateJavaScript("enableDarkTheme(true)", completionHandler: nil)
		}
	}

}

extension NotePreviewViewController: WKNavigationDelegate {

	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		webView.evaluateJavaScript(
			"enableDarkTheme(\(currentTheme == .Default ? "false": "true"))",
			completionHandler: nil)
		guard let escapedNote = noteContent
			.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) else {
			fatalError()
		}

		webView.evaluateJavaScript("loadNote(\"\(escapedNote)\")", completionHandler: nil)
	}

}
