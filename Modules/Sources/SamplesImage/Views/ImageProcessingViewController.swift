//
//  ImageProcessingViewController.swift
//  
//
//  Created by Vasil Zarubanau on 19/08/2023.
//

import Foundation
import UIKit

@MainActor
protocol ImageProcessingViewProtocol: UIViewController {
	func set(title: String)
	func set(image: UIImage)
	func set(progressActive: Bool)

	func apply(filters: [FilterViewModel])
	func apply(attributes: FilterAttributesViewModel)
}

typealias ImageProcessingFiltersSnapshot = NSDiffableDataSourceSnapshot<Int, FilterViewModel>
typealias ImageProcessingFiltersDataSource = UICollectionViewDiffableDataSource<Int, FilterViewModel>

final class ImageProcessingViewController: UIViewController {
	@IBOutlet weak var filtersCollectionView: UICollectionView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	private var presenter: ImageProcessingPresenterProtocol!
	private var filtersCollectionDataSource: ImageProcessingFiltersDataSource!

	init(presenter: ImageProcessingPresenterProtocol) {
    super.init(nibName: "ImageProcessingViewController", bundle: Bundle.module)
		self.presenter = presenter
  }

	@available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		configureDataSource(collectionView: filtersCollectionView)
	}

	@objc func rightBarButtonItemAction() {
		presenter.requestPickImage()
	}
}

private extension ImageProcessingViewController {
	func configureUI() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonItemAction))

		filtersCollectionView.register(ImageProcessingFilterCell.self, forCellWithReuseIdentifier: ImageProcessingFilterCell.reuseIdentifier)
	}

	func configureDataSource(collectionView: UICollectionView) {
		filtersCollectionDataSource = ImageProcessingFiltersDataSource(collectionView: collectionView) { (collectionView, indexPath, viewModel) -> UICollectionViewCell? in
			guard
				let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: ImageProcessingFilterCell.reuseIdentifier,
					for: indexPath
				) as? ImageProcessingFilterCell else { return nil }

			cell.update(with: viewModel)

			return cell
		}
		collectionView.dataSource = filtersCollectionDataSource
		collectionView.delegate = self
	}

	func setFiltersCollectionView(hidden: Bool, animated: Bool) {

		guard (filtersCollectionView.alpha == 1) == hidden else { return }
		guard animated else {
			filtersCollectionView.alpha = hidden ? 0 : 1
			return
		}

		UIView.animate(withDuration: Constants.filtersCollectionViewAppearanceAnimationDuration) {
			self.filtersCollectionView.alpha = hidden ? 0 : 1
		}
	}
}

extension ImageProcessingViewController: ImageProcessingViewProtocol {
	func set(title: String) {
		self.navigationItem.title = title
	}

	func set(image: UIImage) {
		imageView.image = image
	}

	func apply(filters: [FilterViewModel]) {

		var snapshot = ImageProcessingFiltersSnapshot()

		if !filters.isEmpty {
			snapshot.appendSections([0])
			snapshot.appendItems(filters, toSection: 0)
		}

		setFiltersCollectionView(hidden: filters.isEmpty, animated: true)
		filtersCollectionDataSource.apply(snapshot, animatingDifferences: true)
	}

	func set(progressActive active: Bool) {
		if active {
			activityIndicator.startAnimating()
		} else {
			activityIndicator.stopAnimating()
		}
	}

	func apply(attributes: FilterAttributesViewModel) {
		
	}
}

extension ImageProcessingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter.selectFilter(at: indexPath.item)
	}
}

private extension ImageProcessingViewController {
	enum Constants {
		static let filtersCollectionViewAppearanceAnimationDuration: TimeInterval = 1
	}
}
