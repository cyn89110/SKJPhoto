//
//  SKJPhotoViewModel.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import Foundation
import Photos

protocol SKJPhotoViewModelInternalDelegate: AnyObject{

	func photoDidLoad()
}

public protocol SelectorSpec {

	func initSetup()
	func selectItem(at index: Int)
	var dataSource: SelectorDatasource! { get set }
}

public class SKJPhotoViewModel: SelectorDatasource{

	var selector: SelectorSpec!
	var configure: SKJPhotoConfigure{
		didSet{
			fetchPhotos()
		}
	}

	public init(configure: SKJPhotoConfigure, selector: SelectorSpec){
		self.configure = configure
		self.selector = selector
		self.selector.dataSource = self
	}
	
	weak var internalDelegate: SKJPhotoViewModelInternalDelegate?

	public var photos : [SKJPhotoModel] = []

	func selectItem(at index: Int){

		selector.selectItem(at: index)
	}

	func cellViewModel(at index: Int) -> SKJPhotoCollectionViewCellViewModel{

		let viewModel = SKJPhotoCollectionViewCellViewModel.init(model: photos[index])
		viewModel.multiplier = configure.multiplier
		viewModel.circleMultiplier = configure.circleMultiplier
		viewModel.backgroundColor = configure.circleColor
		viewModel.tintColor = configure.tintColor
		viewModel.maskColor = configure.maskColor
		return viewModel
	}

	public func fetchPhotos(){

		let fetchOoptions = PHFetchOptions.init()

		fetchOoptions.sortDescriptors = [.init(key: "creationDate", ascending: false)]

		let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOoptions)

		DispatchQueue.global(qos: .background).async {

			allPhotos.enumerateObjects { (asset, count, stop) in

				self.photos.append(SKJPhotoModel.init(asset: asset))

				if (count + 1 == allPhotos.count){

					DispatchQueue.main.async {

						self.selector.initSetup()
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


