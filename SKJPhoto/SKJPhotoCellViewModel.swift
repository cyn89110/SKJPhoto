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

	func setupImage(image: UIImage?)
	func setupLabel()
}

public class SKJPhotoCollectionViewCellViewModel: SKJPhotoModelDelegate{

	func refreshImage(image: UIImage?) {
		delegate?.setupImage(image: image)
	}

	func orderDidChanged() {
		delegate?.setupLabel()
	}

	weak var delegate: PhotoCellViewModelDelegate?{
		didSet{
			delegate?.setupLabel()
			delegate?.setupImage(image: nil)
		}
	}

	var isOrderLabelHidden: Bool{
		return model.order == 0
	}

	var order: String?{
		return model.order > 0 ? "\(model.order)" : nil
	}

	var model: SKJPhotoModel

	init(model: SKJPhotoModel){

		self.model = model
		self.model.delegate = self
		self.model.fetchImage()
	}
}

