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

	func refreshImage(image: UIImage?)
	func statusChanged()
}

public class SKJPhotoModel: Equatable{

	public static func == (lhs: SKJPhotoModel, rhs: SKJPhotoModel) -> Bool {
		return lhs.asset === rhs.asset && lhs.order == rhs.order
	}

	init(asset: PHAsset) {
		self.asset = asset
	}

	var asset: PHAsset

	var isNumberHidden: Bool = true{
		didSet{
			delegate?.statusChanged()
		}
	}

	var isMask: Bool = false{
		didSet{
			delegate?.statusChanged()
		}
	}

	weak var delegate: SKJPhotoModelDelegate?{
		didSet{
			delegate?.statusChanged()
		}
	}

	var order: Int = 0{
		didSet{
			delegate?.statusChanged()
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
