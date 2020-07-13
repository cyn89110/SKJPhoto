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

	func instagramSelector(current photo: PHAsset) {

		PHImageManager.default().requestImage(for: photo, targetSize: CGSize.init(width: imageView.frame.width, height: imageView.frame.height), contentMode: .aspectFill, options: .none, resultHandler: { (image, nil) in

			self.imageView.image = image
		})
	}

	func instagramSelector(selectedPhotos: [PHAsset]) {
		multipleButton.setTitle("\(selectedPhotos.count) / \(selector.max)", for: .normal)
	}

	lazy var multipleButton: UIButton = {

		let btn = UIButton.init()
		btn.addTarget(self, action: #selector(multipleButtonTapped), for: .touchUpInside)
		return btn
	}()

	lazy var imageView: UIImageView = {
		let imv = UIImageView.init()
		return imv
	}()

	lazy var selector = InstagramSelector.init(max: 15, delegate: self)

	lazy var photoView: SKJPhotoView = {

		let viewModel = SKJPhotoViewModel.init(configure: .instagram, selector: selector)
		let view = SKJPhotoView.init(viewModel: viewModel, frame: .zero)
		viewModel.fetchPhotos()
		return view
	}()

	@objc func multipleButtonTapped(){

		if(selector.max > 1){
			selector.max = 1
		}else{
			selector.max = 15
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

		view.addSubview(multipleButton)
		multipleButton.translatesAutoresizingMaskIntoConstraints = false
		multipleButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
		multipleButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
		multipleButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
		multipleButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true

		view.addSubview(photoView)
		photoView.translatesAutoresizingMaskIntoConstraints = false
		photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		photoView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
		photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
}

