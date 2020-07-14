# SKJPhotos

A framework that allows you to select photos and custom select logic with few lines of code.

# Overview

Instagram & Line style selector provided.

Custom configure for apperance provided.

# Creating

	var selector: InstagramSelector?

	lazy var photoView: SKJPhotoView = {

		let view = SKJPhotoView(frame: .zero)
		view.configure = .instagram
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()

		selector = InstagramSelector.init(max: 10, delegate: self, view: photoView)
		photoView.fetchPhotos()
	}
