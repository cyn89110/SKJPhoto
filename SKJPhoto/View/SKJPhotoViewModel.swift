//
//  SKJPhotoViewModel.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation
import Photos

public protocol SKJPhotoViewModelDelegate: AnyObject {
	func currentPhotoChanged()
	func selectedPhotosChanged()
}

protocol SKJPhotoViewModelInternalDelegate: AnyObject{

	func photoDidLoad()
}

public enum SelectionMode{
	case single
	case multiple
}

public class SKJPhotoViewModel{

	var configure: SKJPhotoConfigure

	public init(configure: SKJPhotoConfigure){
		self.configure = configure
	}

	public var mode: SelectionMode = .multiple{
		didSet{
			switch(mode){
			case .single:
				photos.forEach { (photo) in
					photo.isMultiSelect = false
				}
			case .multiple:
				photos.forEach { (photo) in
					photo.isMultiSelect = true
				}
			}
		}
	}

	public weak var delegate: SKJPhotoViewModelDelegate?{
		didSet{
			fetchPhotos()
		}
	}
	
	weak var internalDelegate: SKJPhotoViewModelInternalDelegate?

	var photos : [SKJPhotoModel] = []
	var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.selectedPhotosChanged()
		}
	}
	var currentPhoto: SKJPhotoModel?{

		didSet{
			oldValue?.isMask = false
			currentPhoto?.isMask = true
		}
	}

	func selectItem(at index: Int){

		guard index > -1 else{
			return
		}

		guard photos.count > index
			else{
				return
		}

		let photo = photos[index]

		if(configure.limit == 1){

			selectedPhotos = [photo]
			return
		}

		if(photo.order > 0){

			if(photo !== currentPhoto){
				currentPhoto = photo
				return
			}

			photo.order = 0
			selectedPhotos.removeAll { (model) -> Bool in
				return model === photo
			}

			var index = 1
			selectedPhotos.forEach { (model) in
				model.order = index
				index = index + 1
			}

			if let lastPhoto = selectedPhotos.last{
				currentPhoto = lastPhoto
			}

		}else{

			if(configure.limit == selectedPhotos.count){
				return
			}

			currentPhoto = photo
			selectedPhotos.append(photo)
			photo.order = selectedPhotos.count
		}
	}

	func cellViewModel(at index: Int) -> SKJPhotoCollectionViewCellViewModel{

		let viewModel = SKJPhotoCollectionViewCellViewModel.init(model: photos[index])
		viewModel.multiplier = configure.multiplier
		viewModel.circleMultiplier = configure.circleMultiplier
		viewModel.backgroundColor = configure.circleColor
		viewModel.tintColor = configure.tintColor
		return viewModel
	}

	func fetchPhotos(){

		let fetchOoptions = PHFetchOptions.init()

		fetchOoptions.sortDescriptors = [.init(key: "creationDate", ascending: false)]

		let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOoptions)

		DispatchQueue.global(qos: .background).async {

			allPhotos.enumerateObjects { (asset, count, stop) in

				self.photos.append(SKJPhotoModel.init(asset: asset))

				if (count + 1 == allPhotos.count){

					DispatchQueue.main.async {

						self.internalDelegate?.photoDidLoad()
					}
				}
			}
		}
	}

	func width(frame: CGRect) -> CGFloat{

		let numberOfSpace = configure.numberOfItemsInRow - 1
		let space = CGFloat(numberOfSpace) * 1.0
		let fill = frame.width - space
		let itemSize = fill / CGFloat(configure.numberOfItemsInRow)
		return floor(itemSize)
	}
}


