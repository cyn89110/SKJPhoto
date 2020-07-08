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
	func tintColor() -> UIColor
}

public protocol SKJPhotoViewDelegate: AnyObject {
	func selectedPhotosModified(photos: [PHAsset])
}

public class SKJPhotoView: UIView, SKJPhotoViewModelDelegate {

	func photoDidLoad() {
		collectionView.reloadData()
	}

	func selectedPhotosChanged() {

		delegate?.selectedPhotosModified(photos: viewModel.photos.map({$0.asset}))
	}

	public weak var delegate: SKJPhotoViewDelegate?{
		didSet{
			delegate?.selectedPhotosModified(photos: viewModel.photos.map({$0.asset}))
		}
	}


	public weak var dataSource: SKJPhotoViewDatasource?{
		didSet{

			guard let dataSource = dataSource else {
				return
			}

			viewModel.fromTop = dataSource.beginFromTop()
			viewModel.limit = dataSource.maximumNumberOfItems()
			viewModel.numberOfRow = dataSource.numberOfItemsInARow()
			viewModel.fetchPhotos()
		}
	}

	var viewModel: SKJPhotoViewModel!

	public override init(frame: CGRect) {

		super.init(frame: frame)

		viewModel = SKJPhotoViewModel()
		viewModel.delegate = self
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

extension SKJPhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		viewModel.selectItem(at: indexPath.row)
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

		cell.viewModel = viewModel.cellViewModel(at: indexPath.row)
		cell.orderLabel.backgroundColor = dataSource?.tintColor()
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.photos.count
	}
	
}
