//
//  VideoProcessingViewController.swift
//  
//
//  Created by Vasil Zarubanau on 20/08/2023.
//

import Foundation
import UIKit

public final class VideoProcessingViewController: UIViewController {
	private var viewModel: VideoProcessingViewModelProtocol!

	init(viewModel: VideoProcessingViewModelProtocol) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
