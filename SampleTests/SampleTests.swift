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

class SampleTests: XCTestCase {

	func testOutOfRange(){

		let viewModel = SKJPhotoViewModel()
		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())
		viewModel.photos = [photo1,photo2,photo3]
		viewModel.selectItem(at: 10)
	}

	func testMaximumLimit(){

		let viewModel = SKJPhotoViewModel()
		viewModel.limit = 2

		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())

		viewModel.photos = [photo1,photo2,photo3]
		viewModel.selectItem(at: 0)
		viewModel.selectItem(at: 1)
		XCTAssertEqual(viewModel.selectedPhotos.count, 2)
		viewModel.selectItem(at: 2)
		XCTAssertEqual(viewModel.selectedPhotos.count, 2)
	}

	func testComplexSelection(){

		let viewModel = SKJPhotoViewModel()
		viewModel.limit = 3

		let photo1 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo2 = SKJPhotoModel.init(asset: PHAsset.init())
		let photo3 = SKJPhotoModel.init(asset: PHAsset.init())

		viewModel.photos = [photo1,photo2,photo3]

		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(viewModel.selectedPhotos, [])

		// Select first pic
		viewModel.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(viewModel.selectedPhotos, [photo1])

		// Select second pic
		viewModel.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 2)
		XCTAssertEqual(photo3.order, 0)
		XCTAssertEqual(viewModel.selectedPhotos, [photo1,photo2])

		// Select third pic
		viewModel.selectItem(at: 2)
		XCTAssertEqual(photo1.order, 1)
		XCTAssertEqual(photo2.order, 2)
		XCTAssertEqual(photo3.order, 3)
		XCTAssertEqual(viewModel.selectedPhotos, [photo1,photo2,photo3])

		// Select first pic
		viewModel.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 0)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 2)
		XCTAssertEqual(viewModel.selectedPhotos, [photo2,photo3])

		// Select first pic
		viewModel.selectItem(at: 0)
		XCTAssertEqual(photo1.order, 3)
		XCTAssertEqual(photo2.order, 1)
		XCTAssertEqual(photo3.order, 2)
		XCTAssertEqual(viewModel.selectedPhotos, [photo2,photo3,photo1])

		// Select first Pic
		viewModel.selectItem(at: 1)
		XCTAssertEqual(photo1.order, 2)
		XCTAssertEqual(photo2.order, 0)
		XCTAssertEqual(photo3.order, 1)
		XCTAssertEqual(viewModel.selectedPhotos, [photo3,photo1])
	}

}
