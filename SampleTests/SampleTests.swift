//
//  SampleTests.swift
//  SampleTests
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import XCTest
@testable import SKJPhoto

class SampleTests: XCTestCase {

	var view: SKJPhotoView!

	func test(){

		view = SKJPhotoView.init(frame: .zero)

		view.fetchPhotos()
	}

}
