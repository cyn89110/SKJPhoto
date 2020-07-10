//
//  Selector.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/10.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation

public protocol SelectorDatasource: AnyObject{
	
	var photos: [SKJPhotoModel]{ get set }
}

public class InstagramSelector: SelectorSpec{

	public init(max: Int) { self.max = max}

	public var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			
		}
	}

	weak public var dataSource: SelectorDatasource!

	var max: Int

	var currentPhoto: SKJPhotoModel?{

		didSet{
			oldValue?.isMask = false
			currentPhoto?.isMask = true
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

			if(max == selectedPhotos.count){
				return
			}

			currentPhoto = photo
			selectedPhotos.append(photo)
			photo.order = selectedPhotos.count
		}
	}
}
