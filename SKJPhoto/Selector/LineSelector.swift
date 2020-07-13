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

	public func initSetup() {}

	public weak var delegate: LineSelectorDelegate?

	public weak var dataSource: SelectorDatasource!

	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.lineSelector(selected: selectedPhotos.map({$0.asset}))
		}
	}

	public init(delegate: LineSelectorDelegate){
		self.delegate = delegate
	}

	private func isIndexValid(index: Int) -> Bool{

		if(index < 0){
			return false
		}
		if(dataSource.photos.count < index){
			return false
		}
		return true
	}

	private func deselect(photo: SKJPhotoModel){

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
	}

	private func select(photo: SKJPhotoModel?){

		guard let photo = photo else {
			return
		}

		photo.isMask = true
		selectedPhotos.append(photo)
		photo.order = selectedPhotos.count
	}

	public func selectItem(at index: Int) {

		guard isIndexValid(index: index) else{
			return
		}

		let photo = dataSource.photos[index]

		photo.order > 0 ? deselect(photo: photo) : select(photo: photo)

	}
}

