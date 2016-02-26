//
//  ExportTemplateView.swift
//  X2015
//
//  Created by Hang Zhang on 2/19/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class ExportTemplateView: UIView {

	var contentView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	var imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	var logoImageView: UIImageView = {
		let view = UIImageView()
		view.image = UIImage(named: "X2015")
		view.alpha = 0.1
		view.contentMode = .ScaleToFill
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	static var contentViewMargin: CGFloat = 20
	static var imageViewCommonMargin: CGFloat = 10
	static var imageViewBottomMargin: CGFloat = 30
	static var logoImageSideWidth: CGFloat {
		return imageViewBottomMargin - imageViewCommonMargin
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configureViews()
	}

	func configureViews() {
		configureContentView()
		configureScreenshotImageView()
		configureLogoImageView()
	}

	private func configureLogoImageView() {
		contentView.addSubview(logoImageView)
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:[logo(width)]",
				options: .DirectionLeadingToTrailing,
				metrics: ["width": ExportTemplateView.logoImageSideWidth],
				views: ["logo": logoImageView]))
		logoImageView
			.centerXAnchor
			.constraintEqualToAnchor(contentView.centerXAnchor)
			.active = true
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:[logo(width)]-margin-|",
				options: .DirectionLeadingToTrailing,
				metrics: [
					"margin": ExportTemplateView.imageViewCommonMargin,
					"width": ExportTemplateView.logoImageSideWidth
				],
				views: ["logo": logoImageView])
		)
	}

	private func configureScreenshotImageView() {
		contentView.addSubview(imageView)
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|-margin-[imageView]-margin-|",
				options: .AlignAllBaseline,
				metrics: ["margin": ExportTemplateView.imageViewCommonMargin],
				views: ["imageView": imageView]))
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:|-margin-[imageView]-bottomMargin-|",
				options: .DirectionLeadingToTrailing,
				metrics: [
					"margin": ExportTemplateView.imageViewCommonMargin,
					"bottomMargin": ExportTemplateView.imageViewBottomMargin
				],
				views: ["imageView": imageView]))
	}

	private func configureContentView() {
		addSubview(contentView)
		addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|-margin-[contentView]-margin-|",
				options: .DirectionLeadingToTrailing,
				metrics: ["margin": ExportTemplateView.contentViewMargin],
				views: ["contentView": contentView]))
		addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:|-margin-[contentView]-margin-|",
				options: .DirectionLeadingToTrailing,
				metrics: ["margin": ExportTemplateView.contentViewMargin],
				views: ["contentView": contentView]))
	}

	static func generateSnapshot(image: UIImage, theme: Theme) -> UIImage {
		let size = ExportTemplateView.sizeToFit(image)
		let template = ExportTemplateView(frame: CGRect(origin: CGPointZero, size: size))
		template.imageView.image = image
		template.imageView.frame.size = image.size
		template.configureTheme(theme)
		UIGraphicsBeginImageContextWithOptions(template.bounds.size, false, UIScreen.mainScreen().scale)
		template.drawViewHierarchyInRect(template.bounds, afterScreenUpdates: true)
		let snapshot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return snapshot
	}

	private static func sizeToFit(image: UIImage) -> CGSize {
		let contentViewSize = CGSize(
			width: image.size.width + ExportTemplateView.imageViewCommonMargin * 2,
			height: image.size.height +
				ExportTemplateView.imageViewCommonMargin +
				ExportTemplateView.imageViewBottomMargin)
		let wholeSize = CGSize(
			width: contentViewSize.width + ExportTemplateView.contentViewMargin * 2,
			height: contentViewSize.height + ExportTemplateView.contentViewMargin * 2)
		return wholeSize
	}

}

extension ExportTemplateView: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		backgroundColor = UIColor.clearColor()
		switch theme {
		case .Default:
			backgroundColor = UIColor.default_ViewControllerBackgroundColor()
			contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
		case .Night:
			backgroundColor = UIColor.night_ViewControllerBackgroundColor()
			contentView.layer.borderColor = UIColor.blackColor().CGColor
		}

		contentView.layer.borderWidth = 1
		contentView.layer.cornerRadius = 5
	}

}
