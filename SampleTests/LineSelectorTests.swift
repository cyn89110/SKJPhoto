//
//  LineSelectorTests.swift
//  SampleTests
//
//  Created by 蘇冠融 on 2020/7/14.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import XCTest
@testable import SKJPhoto
import Photos

class LineSelectorTests: XCTestCase {

	var selector: LineSelector!
	var photoView: SKJPhotoView!
	var target: Target!

	override func setUp() {
		super.setUp()

		target = Target()
		photoView = SKJPhotoView()
		selector = LineSelector.init(view: photoView, delegate: target)
	}

	class Target: LineSelectorDelegate {

		var photos: [SKJPhotoModel] = []

		func lineSelector(selected photos: [PHAsset]) {
			self.photos = photos.map({ SKJPhotoModel.init(asset: $0) })
		}
	}

	func testOutOfRange(){

		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())

		photoView.photos = [photo1,photo2,photo3]
		selector.selectItem(at: 3)
	}

	func testSelection(){

		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())

		photoView.photos = [photo1,photo2,photo3]

		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(selector.selectedPhotos, [])

		// Select first pic
		selector.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(selector.selectedPhotos, [photo1])

		// Select second pic
		selector.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 2)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(selector.selectedPhotos, [photo1,photo2])

		// Select third pic
		selector.selectItem(at: 2)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 2)
		XCTAssertEqual(photo3.order, 3)
		XCTAssertEqual(selector.selectedPhotos, [photo1,photo2,photo3])

		// Select first pic
		selector.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 2)
		XCTAssertEqual(selector.selectedPhotos, [photo2,photo3])

		// Select first pic
		selector.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 3)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 2)
		XCTAssertEqual(selector.selectedPhotos, [photo2,photo3,photo1])

		// Select first Pic
		selector.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 2)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 1)
		XCTAssertEqual(selector.selectedPhotos, [photo3,photo1])
	}
}

