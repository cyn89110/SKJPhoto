//
//  SKJPhotoCollectionViewCell.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/3.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell, PhotoCellViewModelDelegate{

	func setupImage(image: UIImage?) {
		imageView.image = image
	}

	func setupLabel() {
		orderLabel.text = viewModel.order
		orderLabel.isHidden = viewModel.isOrderLabelHidden
	}

	var viewModel: SKJPhotoCollectionViewCellViewModel!{
		didSet{
			viewModel.delegate = self
		}
	}

	lazy var orderLabel: UILabel = {
		let lb = UILabel.init()
		lb.textColor = .white
		lb.textAlignment = .center
		lb.backgroundColor = .systemRed
		lb.adjustsFontSizeToFitWidth = true
		return lb
	}()

	lazy var imageView: UIImageView = {

		let imv = UIImageView.init(frame: .zero)
		imv.contentMode = .scaleAspectFill
		imv.clipsToBounds = true
		imv.backgroundColor = .systemGray6
		return imv
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		addSubview(orderLabel)
		orderLabel.translatesAutoresizingMaskIntoConstraints = false
		orderLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		orderLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		orderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		orderLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		imageView.image = nil
	}

}

