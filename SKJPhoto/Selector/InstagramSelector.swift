//
//  Selector.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/10.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

public protocol InstagramSelectorDelegate: AnyObject{

	func instagramSelector(current photo: UIImage)
	func instagramSelector(selectedPhotos: [PHAsset])
	func instagramSelectorOverSelect()
	func instagramSelectorEnableToSelect()
}

public protocol InstagramSelectorDatasource: AnyObject{

	func instagramSelectorOutputImageSize() -> CGSize
}

public class InstagramSelector: SelectorSpec{

	public init(max: Int,
				delegate: InstagramSelectorDelegate,
				view: SKJPhotoView) {

		self.max = max
		self.delegate = delegate
		self.photoView = view
		self.photoView?.selector = self
	}

	public weak var photoView: SKJPhotoView?

	public func initSetup() {

		selectedPhotos = []
		currentPhoto = photoView?.photos.first

		if let photo = currentPhoto{
			select(photo: photo)
		}

		max > 1 ? showNumber() : hideNumber()
	}

	weak var delegate: InstagramSelectorDelegate?
	public weak var dataSource: InstagramSelectorDatasource?



	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.instagramSelector(selectedPhotos: selectedPhotos.map({$0.asset}))
			isSelectable = selectedPhotos.count < max
		}
	}

	public func selectItem(at index: Int) {

		guard index > -1 else{
			return
		}

		guard let photoView = photoView else{
			return
		}

		guard photoView.photos.count > index
			else{
				return
		}

		if(max > 1){
			multipleSelect(at: index)
		}else{
			singleSelect(at: index)
		}
	}

	public var max: Int{
		didSet{

			if(oldValue != max){

				reset()

				if(max == 1){
					if let photo = currentPhoto{
						selectedPhotos = [photo]
					}
					hideNumber()
				}

				if(max > 1){

					if let photo = currentPhoto{
						select(photo: photo)
					}
					showNumber()
				}
			}
		}
	}

	var currentPhoto: SKJPhotoModel?{

		didSet{

			oldValue?.isMask = false
			currentPhoto?.isMask = true

			if let asset = currentPhoto?.asset{
				loadImage(asset: asset)
			}
		}
	}

	func reset(){

		selectedPhotos = []
		photoView?.photos.forEach({$0.order = 0})
	}

	func loadImage(asset: PHAsset){

		let options = PHImageRequestOptions()
		options.deliveryMode = .highQualityFormat

		var size = CGSize.init(width: 350, height: 350)
		if let dataSource = dataSource{
			size = dataSource.instagramSelectorOutputImageSize()
		}

		PHImageManager.default().requestImage(for: asset,
											  targetSize: size,
											  contentMode: .aspectFill,
											  options: options,
											  resultHandler: { (image, nil) in

												if let image = image{
													self.delegate?.instagramSelector(current: image)
												}

		})
	}

	func showNumber(){
		photoView?.photos.forEach({$0.isNumberHidden = false})
	}

	func hideNumber(){
		photoView?.photos.forEach ({$0.isNumberHidden = true})
	}

	func singleSelect(at index: Int){

		guard let photo = photoView?.photos[index] else{
			return
		}
		currentPhoto = photo
		selectedPhotos = [photo]
	}

	func multipleSelect(at index: Int){

		guard let photo = photoView?.photos[index] else{
			return
		}

		if(photo.order > 0){

			if(photo !== currentPhoto){
				currentPhoto = photo
				return
			}

			deselect(photo: photo)

		}else{

			select(photo: photo)
		}
	}

	var isSelectable: Bool = false{
		didSet{
			if oldValue != isSelectable{
				isSelectable ? delegate?.instagramSelectorEnableToSelect() : delegate?.instagramSelectorOverSelect()
			}
		}
	}

	func select(photo: SKJPhotoModel){

		guard isSelectable else {
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
