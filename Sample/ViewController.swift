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

class ViewController: UIViewController, SKJPhotoViewModelDelegate {

	func currentPhotoChanged() {

	}

	func selectedPhotosChanged() {

	}

	lazy var photoView: SKJPhotoView = {

		let viewModel = SKJPhotoViewModel.init(configure: .line)
		let view = SKJPhotoView.init(viewModel: viewModel, frame: .zero)
		viewModel.delegate = self
		viewModel.mode = .multiple
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

