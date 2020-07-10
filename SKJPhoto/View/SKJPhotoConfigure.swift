//
//  SKJPhotoConfigure.swift
//  SKJPhoto
//
//  Created by 蘇冠融 on 2020/7/8.
//  Copyright © 2020 蘇冠融. All rights reserved.
//

import UIKit

public struct SKJPhotoConfigure {

	public static var instagram: Self{
		return SKJPhotoConfigure.init(fromTop: true,
									  limit: 10,
									  numberOfItemsInRow: 4,
									  multiplier: 0.3,
									  circleMultiplier: 0.75,
									  maskColor: .init(white: 1.0, alpha: 0.4),
									  circleColor: .init(white: 1.0, alpha: 0.4),
									  tintColor: .systemBlue)
	}

	public static var line: Self{
		return SKJPhotoConfigure.init(fromTop: true,
									  limit: 10,
									  numberOfItemsInRow: 3,
									  multiplier: 0.3,
									  circleMultiplier: 0.6,
									  maskColor: .init(white: 0.0, alpha: 0.4),
									  circleColor: .clear,
									  tintColor: .init(red: 0, green: 195/255, blue: 0, alpha: 1.0))
	}
	var fromTop: Bool = true
	var limit:Int = 15
	var numberOfItemsInRow: Int = 4
	var multiplier: CGFloat
	var circleMultiplier: CGFloat
	var maskColor: UIColor
	var circleColor: UIColor
	var tintColor: UIColor
}
