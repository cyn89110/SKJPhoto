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

	func reload() {
		whiteView.isHidden = viewModel.isMaskHidden
		imageView.image = viewModel.image
		orderLabel.text = viewModel.order
		rightTopView.isHidden = viewModel.isOrderLabelHidden
		orderLabel.backgroundColor = viewModel.labelBackgroudColor
	}

	var viewModel: SKJPhotoCollectionViewCellViewModel!{
		didSet{
			setupUI()
			viewModel.delegate = self
		}
	}

	lazy var whiteView: UIView = {

		let view = UIView.init()
		view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
		return view
	}()

	lazy var orderLabel: UILabel = {
		let lb = UILabel.init()
		lb.textColor = .white
		lb.textAlignment = .center
		lb.backgroundColor = .systemBlue
		lb.layer.borderColor = UIColor.white.cgColor
		lb.layer.borderWidth = 1.0
		lb.layer.masksToBounds = true
		lb.adjustsFontSizeToFitWidth = true
		lb.font = .systemFont(ofSize: 13.0)
		return lb
	}()

	lazy var imageView: UIImageView = {

		let imv = UIImageView.init(frame: .zero)
		imv.contentMode = .scaleAspectFill
		imv.clipsToBounds = true
		imv.backgroundColor = .systemGray6
		return imv
	}()

	lazy var rightTopView: UIView = {

		let view = UIView.init()
		view.backgroundColor = .clear
		return view
	}()

	func setupUI(){

		addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		addSubview(whiteView)
		whiteView.translatesAutoresizingMaskIntoConstraints = false
		whiteView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		whiteView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		whiteView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		whiteView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		addSubview(rightTopView)
		rightTopView.translatesAutoresizingMaskIntoConstraints = false
		rightTopView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		rightTopView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		rightTopView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.multiplier).isActive = true
		rightTopView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: viewModel.multiplier).isActive = true

		rightTopView.addSubview(orderLabel)
		orderLabel.translatesAutoresizingMaskIntoConstraints = false
		orderLabel.centerYAnchor.constraint(equalTo: rightTopView.centerYAnchor).isActive = true
		orderLabel.centerXAnchor.constraint(equalTo: rightTopView.centerXAnchor).isActive = true
		orderLabel.widthAnchor.constraint(equalTo: rightTopView.widthAnchor, multiplier: viewModel.circleMultiplier).isActive = true
		orderLabel.heightAnchor.constraint(equalTo: rightTopView.heightAnchor, multiplier: viewModel.circleMultiplier).isActive = true
	}


	override func layoutSubviews() {
		super.layoutSubviews()

		orderLabel.layer.cornerRadius = orderLabel.frame.width / 2
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		imageView.image = nil
	}

}

