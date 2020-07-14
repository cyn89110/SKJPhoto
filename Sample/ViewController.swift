//
//  ViewController.swift
//  Sample
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import SKJPhoto
import Photos

class ViewController: UIViewController, InstagramSelectorDelegate {

	func instagramSelector(current photo: SKJPhotoModel) {
		loadImage(asset: photo.asset)
	}

	func instagramSelector(selectedPhotos: [SKJPhotoModel]) {

		guard let selector = selector else {
			return
		}
		if(selector.max > 1){
			statusButton.setTitle("\(selectedPhotos.count) / \(selector.max)", for: .normal)
		}else{
			statusButton.setTitle(nil, for: .normal)
		}
	}


	func instagramSelectorOverSelect() {
		print("Can not select more.")
	}

	func instagramSelectorEnableToSelect() {
		print("Enable to select more.")
	}

	func instagramSelector(current photo: UIImage) {
		imageView.image = photo
	}

	lazy var statusButton: UIButton = {

		let btn = UIButton.init()
		btn.backgroundColor = .init(white: 0, alpha: 0.5)
		btn.addTarget(self, action: #selector(multipleButtonTapped), for: .touchUpInside)
		return btn
	}()

	lazy var imageView: UIImageView = {
		let imv = UIImageView.init()
		imv.contentMode = .scaleAspectFill
		imv.clipsToBounds = true
		return imv
	}()

	var selector: InstagramSelector?

	lazy var photoView: SKJPhotoView = {

		let view = SKJPhotoView(frame: .zero)
		view.configure = .instagram
		return view
	}()

	@objc func multipleButtonTapped(){

		guard let selector = selector else{
			return
		}

		if(selector.max > 1){
			selector.max = 1
		}else{
			selector.max = 10
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()

		selector = InstagramSelector.init(max: 10, delegate: self, view: photoView)
		photoView.fetchPhotos()
	}

	func loadImage(asset: PHAsset){

		let options = PHImageRequestOptions()
		options.deliveryMode = .highQualityFormat

		PHImageManager.default().requestImage(
			for: asset,
			targetSize: CGSize.init(width: imageView.frame.width, height: imageView.frame.height),
			contentMode: .aspectFill,
			options: options,
			resultHandler: { (image, nil) in

				self.imageView.image = image
		})
	}


	func setupUI(){

		view.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

		view.addSubview(statusButton)
		statusButton.translatesAutoresizingMaskIntoConstraints = false
		statusButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
		statusButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
		statusButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
		statusButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true

		view.addSubview(photoView)
		photoView.translatesAutoresizingMaskIntoConstraints = false
		photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		photoView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 1.0).isActive = true
		photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

