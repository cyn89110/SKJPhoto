# SKJPhoto

Usage Example:

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
