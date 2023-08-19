//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 21/08/2023.
//

import Foundation
import UIKit

final class ImageProcessingFilterCell: UICollectionViewCell {
	static let reuseIdentifier: String = "ImageProcessingFilterCell"

	private let containerView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
		view.backgroundColor = .clear
		return view
	}()

	private let imageView = {
		UIImageView()
	}()

	private let label = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.backgroundColor = .black.withAlphaComponent(0.5)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(with viewModel: FilterViewModel) {
		label.text = viewModel.title
		imageView.image = viewModel.thumbnail

		containerView.layer.borderColor = viewModel.isSelected ? UIColor.white.cgColor : nil
		containerView.layer.borderWidth = viewModel.isSelected ? 2 : 0
	}

	// MARK: Private
	private func configureUI() {

		containerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(containerView)
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])

		imageView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])

		label.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(label)

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])
	}
}
