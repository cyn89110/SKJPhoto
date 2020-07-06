//
//  VideoModel.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

protocol SKJPhotoModelDelegate: AnyObject {

	func orderDidChanged()
	func refreshImage(image: UIImage?)
}

public class SKJPhotoModel{

	init(asset: PHAsset) {
		self.asset = asset
	}

	var asset: PHAsset

	weak var delegate: SKJPhotoModelDelegate?{
		didSet{
			delegate?.orderDidChanged()
		}
	}

	var order: Int = 0{
		didSet{
			delegate?.orderDidChanged()
		}
	}

	func fetchImage(){

		PHImageManager
			.default()
			.requestImage(for: self.asset, targetSize: CGSize.init(width: 250, height: 250), contentMode: .aspectFit, options: nil) { (image, info) in

				DispatchQueue.main.async {

					self.delegate?.refreshImage(image: image)
				}
		}
	}
}
