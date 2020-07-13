//
//  SKJPhotoViewController.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

public class SKJPhotoView: UIView, SKJPhotoViewModelInternalDelegate {

	func photoDidLoad() {
		collectionView.reloadData()
	}

	var viewModel: SKJPhotoViewModel!

	public init(viewModel: SKJPhotoViewModel, frame: CGRect){

		super.init(frame: frame)
		self.viewModel = viewModel
		self.viewModel.internalDelegate = self
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
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let width = viewModel.width(frame: collectionView.frame)
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
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.photos.count
	}
	
}
