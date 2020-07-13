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

	public weak var photoView: SKJPhotoView?

	public func initSetup() {}

	public weak var delegate: LineSelectorDelegate?

	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.lineSelector(selected: selectedPhotos.map({$0.asset}))
		}
	}

	public init(view: SKJPhotoView,delegate: LineSelectorDelegate){
		self.delegate = delegate
		self.photoView = view
	}

	private func isIndexValid(index: Int) -> Bool{

		if(index < 0){
			return false
		}

		guard let photoView = photoView else{
			return false
		}
		if(photoView.photos.count < index){
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

		guard let photo = photoView?.photos[index] else{
			return
		}

		photo.order > 0 ? deselect(photo: photo) : select(photo: photo)

	}
}

