//
//  SKJPhotoViewController.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

public protocol SelectorSpec: AnyObject {

	func initSetup()
	func selectItem(at index: Int)
	var photoView: SKJPhotoView? { get set }
}

public class SKJPhotoView: UIView {

	func photoDidLoad() {
		collectionView.reloadData()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupUI(){

		backgroundColor = .systemBackground
		addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	
	lazy var collectionView: UICollectionView = {
		
		let layout = UICollectionViewFlowLayout.init()
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.delegate = self
		cv.dataSource = self
		cv.alwaysBounceVertical = true
		cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		return cv
	}()

	public weak var selector: SelectorSpec?

	public var configure: SKJPhotoConfigure?

	public var photos : [SKJPhotoModel] = []
}

extension SKJPhotoView{

	func selectItem(at index: Int){

		selector?.selectItem(at: index)
	}

	func cellViewModel(at index: Int) -> SKJPhotoCollectionViewCellViewModel{

		let viewModel = SKJPhotoCollectionViewCellViewModel.init(model: photos[index])
		viewModel.multiplier = configure?.multiplier ?? 0
		viewModel.circleMultiplier = configure?.circleMultiplier ?? 0
		viewModel.backgroundColor = configure?.circleColor
		viewModel.tintColor = configure?.tintColor
		viewModel.maskColor = configure?.maskColor
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

						self.selector?.initSetup()
						self.collectionView.reloadData()
					}
				}
			}
		}
	}

	func itemWidth(frame: CGRect) -> CGFloat{

		guard let configure = configure else{
			return 0
		}

		let numberOfSpace = configure.numberOfItemsInRow - 1
		let space = CGFloat(numberOfSpace) * 1.0
		let fill = frame.width - space
		let itemSize = fill / CGFloat(configure.numberOfItemsInRow)
		return floor(itemSize)
	}

}

extension SKJPhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		selectItem(at: indexPath.row)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let width = itemWidth(frame: collectionView.frame)
		return CGSize.init(width: width, height: width)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell

		cell.viewModel = cellViewModel(at: indexPath.row)
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
}
