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

class ViewController: UIViewController, SKJPhotoViewDatasource, SKJPhotoViewDelegate {

	func selectedPhotosModified(photos: [PHAsset]) {
		print(photos.count)
	}

	func numberOfItemsInARow() -> Int {
		return 3
	}

	func maximumNumberOfItems() -> Int {
		return 15
	}

	func beginFromTop() -> Bool {
		return true
	}


	func tintColor() -> UIColor {
		return .systemBlue
	}

	lazy var photoView: SKJPhotoView = {
		let view = SKJPhotoView.init(frame: .zero)
		view.dataSource = self
		view.delegate = self
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(photoView)
		photoView.translatesAutoresizingMaskIntoConstraints = false
		photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

}

