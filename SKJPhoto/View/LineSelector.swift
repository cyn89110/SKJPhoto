//
//  LineSelector.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/10.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation
import Photos

public protocol LineSelectorDelegate: AnyObject{

	func lineSelector(selected photos: [PHAsset])
}

public class LineSelector: SelectorSpec{

	public weak var delegate: LineSelectorDelegate?

	public weak var dataSource: SelectorDatasource!

	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.lineSelector(selected: selectedPhotos.map({$0.asset}))
		}
	}

	var max: Int

	public init(max: Int, delegate: LineSelectorDelegate){
		self.max = max
		self.delegate = delegate
	}

	public func selectItem(at index: Int) {

		guard index > -1 else{
			return
		}

		guard dataSource.photos.count > index
			else{
				return
		}

		let photo = dataSource.photos[index]

		if(max == 1){

			selectedPhotos = [photo]
			return
		}

		if(photo.order > 0){

			photo.isMask = false
			photo.order = 0

			selectedPhotos.removeAll { (model) -> Bool in
				return model === photo
			}

			var index = 1
			selectedPhotos.forEach { (model) in
				model.order = index
				index = index + 1
			}

		}else{

			if(max == selectedPhotos.count){
				return
			}

			photo.isMask = true
			selectedPhotos.append(photo)
			photo.order = selectedPhotos.count
		}
	}
}

