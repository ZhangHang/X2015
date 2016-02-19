//
//  ExportTemplateView.swift
//  X2015
//
//  Created by Hang Zhang on 2/19/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class ExportTemplateView: UIView {

	var contentView: UIView = UIView()
	var imageView: UIImageView = UIImageView()

	static var contentViewMargin: CGFloat = 20
	static var imageViewCommonMargin: CGFloat = 10
	static var imageViewBottomMargin: CGFloat = 30

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configureViews()
	}

	func configureViews() {
		contentView.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|-margin-[contentView]-margin-|",
				options: .AlignAllBaseline,
				metrics: ["margin": ExportTemplateView.contentViewMargin],
				views: ["contentView": contentView]))
		addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:|-margin-[contentView]-margin-|",
				options: .AlignAllBaseline,
				metrics: ["margin": ExportTemplateView.contentViewMargin],
				views: ["contentView": contentView]))

		contentView.addSubview(imageView)
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|-margin-[imageView]-margin-|",
				options: .AlignAllBaseline,
				metrics: ["margin": ExportTemplateView.imageViewCommonMargin],
				views: ["imageView": imageView]))
		contentView.addConstraints(
			NSLayoutConstraint.constraintsWithVisualFormat(
				"V:|-topMargin-[imageView]-bottomMargin-|",
				options: .AlignAllBaseline,
				metrics: [
					"topMargin": ExportTemplateView.imageViewCommonMargin,
					"bottomMargin": ExportTemplateView.imageViewBottomMargin],
				views: ["imageView": imageView]))
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
			contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
		}

		contentView.layer.borderWidth = 1
		contentView.layer.cornerRadius = 5
	}

}
