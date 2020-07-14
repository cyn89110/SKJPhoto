//
//  SampleTests.swift
//  SampleTests
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import XCTest
@testable import SKJPhoto
import Photos

class InstagramSelectorTests: XCTestCase {

	class Target: InstagramSelectorDelegate{

		var currentPhoto: SKJPhotoModel?
		var photos: [SKJPhotoModel] = []

		func instagramSelector(current photo: SKJPhotoModel) {
			currentPhoto = photo
		}

		func instagramSelector(selectedPhotos: [SKJPhotoModel]) {
			photos = selectedPhotos
		}

		func instagramSelectorOverSelect() {

		}

		func instagramSelectorEnableToSelect() {

		}
	}

	var selector: InstagramSelector!
	var photoView: SKJPhotoView!
	var target: Target!

	override func setUp() {
		super.setUp()

		target = Target()
		photoView = SKJPhotoView()
		selector = InstagramSelector.init(max: 15, delegate: target, view: photoView)
	}

	func testSelection(){

		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())

		photoView.photos = [photo1,photo2,photo3]

		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(target.photos, [photo1])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo1)
		}

		// Select first pic
		selector.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(target.photos, [])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo1)
		}

		// Select second pic
		selector.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(target.photos, [photo2])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo2)
		}

		// Select third pic
		selector.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 2)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(target.photos, [photo2,photo1])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo1)
		}

		// Select first pic
		selector.selectItem(at: 2)
		XCTAssertEqual(photo1.order, 2)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 3)
		XCTAssertEqual(target.photos, [photo2,photo1,photo3])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo3)
		}

		selector.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 2)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 3)
		XCTAssertEqual(target.photos, [photo2,photo1,photo3])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo2)
		}

		selector.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 2)
		XCTAssertEqual(target.photos, [photo1,photo3])

		if let photo = target.currentPhoto{
			XCTAssertEqual(photo, photo3)
		}
	}
}

