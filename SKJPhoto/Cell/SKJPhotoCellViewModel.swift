//
//  SKJPhotoCellViewModel.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

protocol PhotoCellViewModelDelegate: AnyObject {

	func reload()
}

public class SKJPhotoCollectionViewCellViewModel: SKJPhotoModelDelegate{

	func statusChanged() {
		delegate?.reload()
	}

	func refreshImage(image: UIImage?) {
		self.image = image
		delegate?.reload()
	}

	weak var delegate: PhotoCellViewModelDelegate?{
		didSet{
			delegate?.reload()
		}
	}

	var isMaskHidden: Bool{
		return !model.isMask
	}

	var isOrderLabelHidden: Bool{
		return !model.isMultiSelect
	}

	var labelText: String{
		return model.order > 0 ? "\(model.order)" : ""
	}

	var order: String?{
		return model.order > 0 ? "\(model.order)" : nil
	}

	var labelBackgroudColor: UIColor?{
		return model.order > 0 ? tintColor : backgroundColor
	}
	var multiplier: CGFloat = 0.7
	var circleMultiplier: CGFloat = 1/4
	var tintColor: UIColor?
	var backgroundColor: UIColor?
	var maskColor: UIColor?

	var image: UIImage?

	private var model: SKJPhotoModel

	init(model: SKJPhotoModel){

		self.model = model
		self.model.delegate = self
		self.model.fetchImage()
	}
}

