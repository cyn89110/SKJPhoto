//
//  SKJPhotoViewController.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

public protocol SKJPhotoViewDatasource: AnyObject {

	func numberOfItemsInARow() -> Int
	func maximumNumberOfItems() -> Int
	func beginFromTop() -> Bool
}

public protocol SKJPhotoViewDelegate: AnyObject {
	func photosDidEditing(photos: [PHAsset])
}

public class SKJPhotoView: UIView {

	var photos : [SKJPhotoModel] = []
	var selectedPhotos: [SKJPhotoModel] = []{
		didSet{
			delegate?.photosDidEditing(photos: selectedPhotos.map({$0.asset}))
		}
	}

	var fromTop: Bool = true
	var limit:Int = 15
	var numberOfRow: Int = 4

	public weak var delegate: SKJPhotoViewDelegate?{
		didSet{
			delegate?.photosDidEditing(photos: selectedPhotos.map({$0.asset}))
		}
	}


	public weak var dataSource: SKJPhotoViewDatasource?{
		didSet{

			guard let dataSource = dataSource else {
				return
			}

			fromTop = dataSource.beginFromTop()
			limit = dataSource.maximumNumberOfItems()
			numberOfRow = dataSource.numberOfItemsInARow()
			fetchPhotos()
		}
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
}

extension SKJPhotoView{

	public func fetchPhotos(){

		let fetchOoptions = PHFetchOptions.init()
		
		fetchOoptions.sortDescriptors = [.init(key: "creationDate", ascending: false)]

		let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOoptions)

		DispatchQueue.global(qos: .background).async {

			allPhotos.enumerateObjects { [weak self] (asset, count, stop) in

				self?.photos.append(SKJPhotoModel.init(asset: asset))

				if (count + 1 == allPhotos.count){

					DispatchQueue.main.async {

						self?.collectionView.reloadData()
					}
				}
			}
		}
	}
}

extension SKJPhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let photo = photos[indexPath.row]

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

	var width: CGFloat{

		guard let dataSource = dataSource else{
			return (collectionView.frame.width - 3) / 4
		}

		let numberOfSpace = dataSource.numberOfItemsInARow() - 1
		let space = CGFloat(numberOfSpace) * 1.0
		let fill = collectionView.frame.width - space
		let itemSize = fill / CGFloat(dataSource.numberOfItemsInARow())
		return floor(itemSize)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
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

		cell.viewModel = SKJPhotoCollectionViewCellViewModel.init(model: photos[indexPath.row])
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
}
