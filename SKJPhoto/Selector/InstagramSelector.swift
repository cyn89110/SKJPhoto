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

		currentPhoto = dataSource.photos.first

		if(max > 1){
			select(photo: currentPhoto)
		}

		reloadNumber()
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

			if(oldValue != max){

				selectedPhotos = []
				dataSource.photos.forEach({$0.order = 0})

				if(max > 1){

					select(photo: currentPhoto)
					showNumber()

				}else{

					if let photo = currentPhoto{
						selectedPhotos = [photo]
					}
					hideNumber()
				}
			}
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

	func showNumber(){
		dataSource.photos.forEach({$0.isNumberHidden = false})
	}

	func hideNumber(){
		dataSource.photos.forEach ({$0.isNumberHidden = true})
	}

	func reloadNumber(){

		if(max > 1){
			showNumber()
		}
		if(max == 1){
			hideNumber()
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

			currentPhoto = photo
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

	func select(photo: SKJPhotoModel?){

		guard let photo = photo else {
			return
		}

		guard photo.order == 0 else{
			return
		}

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
