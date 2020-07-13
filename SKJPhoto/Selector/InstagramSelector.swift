//
//  Selector.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/10.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation
import Photos

public protocol InstagramSelectorDelegate: AnyObject{

	func instagramSelector(current photo: PHAsset)
	func instagramSelector(selectedPhotos: [PHAsset])
}

public protocol SelectorDatasource: AnyObject{
	
	var photos: [SKJPhotoModel]{ get set }
}

public class InstagramSelector: SelectorSpec{

	public func initSetup() {

		if(max > 1){
			if let photo = dataSource.photos.first{
				select(photo: photo)
			}
		}
		reloadNumber()
	}

	func reloadNumber(){

		if(max > 1){
			dataSource.photos.forEach({$0.isNumberHidden = false})
		}
		if(max == 1){
			dataSource.photos.forEach { (photo) in
				photo.isNumberHidden = true
			}
		}
	}

	weak var delegate: InstagramSelectorDelegate?

	public init(max: Int, delegate: InstagramSelectorDelegate) {
		self.max = max
		self.delegate = delegate
	}

	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.instagramSelector(selectedPhotos: selectedPhotos.map({$0.asset}))
		}
	}

	weak public var dataSource: SelectorDatasource!

	public var max: Int{
		didSet{
			reloadNumber()
		}
	}

	var currentPhoto: SKJPhotoModel?{

		didSet{
			
			oldValue?.isMask = false
			currentPhoto?.isMask = true

			if let asset = currentPhoto?.asset{
				delegate?.instagramSelector(current: asset)
			}
		}
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

			if(photo !== currentPhoto){
				currentPhoto = photo
				return
			}

			deselect(photo: photo)

		}else{

			if(max == selectedPhotos.count){
				return
			}
			select(photo: photo)
		}
	}

	func select(photo: SKJPhotoModel){

		currentPhoto = photo
		selectedPhotos.append(photo)
		photo.order = selectedPhotos.count
	}

	func deselect(photo: SKJPhotoModel){

		photo.order = 0

		selectedPhotos.removeAll { (model) -> Bool in
			return model === photo
		}

		var index: Int = 1
		selectedPhotos.forEach { (model) in
			model.order = index
			index = index + 1
		}

		if let lastPhoto = selectedPhotos.last{
			currentPhoto = lastPhoto
		}
	}
}
