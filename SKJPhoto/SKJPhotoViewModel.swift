//
//  SKJPhotoViewModel.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation
import Photos

protocol SKJPhotoViewModelDelegate: AnyObject{

	func selectedPhotosChanged()
	func photoDidLoad()
}

class SKJPhotoViewModel{

	weak var delegate: SKJPhotoViewModelDelegate?

	var fromTop: Bool = true
	var limit:Int = 15
	var numberOfRow: Int = 4
	var photos : [SKJPhotoModel] = []

	var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.selectedPhotosChanged()
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

		if(limit == 1){

			selectedPhotos = [photo]
			return
		}

		if(photo.order > 0){

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

			if(limit == selectedPhotos.count){
				return
			}

			selectedPhotos.append(photo)
			photo.order = selectedPhotos.count
		}
	}

	func cellViewModel(at index: Int) -> SKJPhotoCollectionViewCellViewModel{
		return SKJPhotoCollectionViewCellViewModel.init(model: photos[index])
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

						self.delegate?.photoDidLoad()
					}
				}
			}
		}
	}
}


